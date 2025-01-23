
import AppCore
import PhotosUI
import SwiftUI

struct MainView: View {
    // MARK: SwiftUI Properties

    @State private var loadFiltersPreviews: Task<Void, Never>? = nil
    @State private var photoEditorService = PhotoEditorService()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showsFilteredImage = true
    @State private var showsFilters: Bool = false
    @State private var showsSettings = true
    @State private var showsTextures = false
    @State private var showsHistogram = false
    @State private var isLoadingFiltersPreviews: Bool = false

    // MARK: Content Properties

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ZStack {
                    Image("grain")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .opacity(0.5)
                    if photoEditorService.finalImage != nil {
                        HStack {
                            Spacer()
                            Button {
                                photoEditorService.saveImageToPhotoLibrary()
                                // TODO: Show successful alert
                            } label: {
                                Text("Export")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .border(Color.textWhite, width: 1)
                            }
                        }
                    }
                }
                //            .onAppear { // Only for testing
                //                if let uiImage = UIImage(named: "Textures/Grain/grain1"),
                //                   let cgImage = uiImage.cgImage {
                //                    self.photoEditorService.updateSourceImage(CIImage(cgImage: cgImage))
                //                }
                //            }
                if let sourceImage = photoEditorService.sourceImage, let filteredImage = photoEditorService.finalImage {
                    VStack {
                        ZStack(alignment: .trailing) {
                            sourceImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.backgroundBlackSecondary.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            filteredImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .opacity(showsFilteredImage ? 1 : 0)
                                .onLongPressGesture {} onPressingChanged: { isPressing in
                                    showsFilteredImage = !isPressing
                                }
                        }
                        .overlay(alignment: .bottomLeading) {
                            if showsHistogram, let histogram = photoEditorService.histogram() {
                                Image(uiImage: histogram)
                                    .resizable()
                                    .opacity(0.8)
                                    .frame(width: 100, height: 50)
                                    .padding()
                            }
                        }
                        HStack(spacing: 0) {
                            Button {
                                showsHistogram.toggle()
                            } label: {
                                Image(systemName: "waveform.path.ecg.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(4)
                                    .tint(showsHistogram ? Color.textBlack : Color.textWhite)
                                    .background(showsHistogram ? Color.backgroundWhiteSecondary.opacity(0.8) : .clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                            .padding(4)
                            Button {
                                selectedItem = nil
                                loadFiltersPreviews?.cancel()
                                photoEditorService.reset()
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(4)
                                    .tint(Color.textWhite)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }

                    ScrollView(.vertical) {
                        VStack(spacing: 8) {
                            filtersView
                            slidersView
                            texturesView
                        }
                    }
                    .scrollIndicators(.hidden)
                } else {
                    photoPickerView
                }
            }
            .padding(.horizontal, 8)
            .background(Color.backgroundBlack)
        }
    }

    private var photoPickerView: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Rectangle()
                .fill(.clear)
                .overlay(alignment: .center) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tint(.white)
                            .frame(width: 20, height: 20)
                        Text("Tap to choose an image\nfrom the gallery.")
                            .font(.custom(size: 12))
                            .foregroundStyle(Color.textWhite)
                    }.opacity(0.5)
                }
        }
        .onChange(of: selectedItem) { _, newValue in
            guard let newValue else { return }
            loadFiltersPreviews?.cancel()
            loadFiltersPreviews = Task {
                isLoadingFiltersPreviews = true
                if let data = try? await newValue.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data), let ciImage = CIImage(data: data)
                {
                    // TODO: Может вместо того, чтобы отдельно передавать CIImage и ориентацию передавать UIImage?
                    photoEditorService.updateSourceImage(ciImage, orientation: uiImage.imageOrientation)
                    print("Start generate previews")
                    await DataStorage.shared.updateFiltersPreviews(with: ciImage)
                    print("Finish generate previews")
                }
                isLoadingFiltersPreviews = false
            }
        }
    }

    private var filtersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                showsFilters.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        Text("Filters")
                            .font(.h4)
                            .foregroundStyle(Color.textWhite.opacity(0.8))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if !isLoadingFiltersPreviews {
                            NavigationLink {
                                GalleryView(type: .filters)
                                    .environment(photoEditorService)
                            } label: {
                                Text("Show all")
                                    .font(.h5)
                                    .italic()
                                    .foregroundStyle(Color.textWhite)
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(showsFilters ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if let finalCiImage = photoEditorService.finalCiImage, showsFilters {
                if isLoadingFiltersPreviews {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.textWhite)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 8) {
                        FiltersScrollView(previewImage: finalCiImage)
                            .environment(photoEditorService)

                        //                    if photoEditorService.hasFilter {
                        //                        VStack(spacing: 0) {
                        //                            HStack {
                        //                                Text("Intensity:")
                        //                                    .font(.h5)
                        //                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                        //                                Text("\(photoEditorService.textureIntensity)")
                        //                                    .font(.h5)
                        //                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                        //                            }
                        //                            .frame(maxWidth: .infinity, alignment: .leading)
                        //                            Slider(value: $photoEditorService.textureIntensity, in: 0...1)
                        //                            .tint(Color.textWhite.opacity(0.1))
                        //                        }
                        //                    }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundBlackSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var texturesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                showsTextures.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        Text("Textures")
                            .font(.h4)
                            .foregroundStyle(Color.textWhite.opacity(0.8))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        NavigationLink {
                            GalleryView(type: .textures)
                                .environment(photoEditorService)
                        } label: {
                            Text("Show all")
                                .font(.h5)
                                .italic()
                                .foregroundStyle(Color.textWhite)
                        }
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(showsTextures ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if showsTextures {
                VStack(spacing: 8) {
                    TexturesScrollView()
                        .environment(photoEditorService)

                    if photoEditorService.hasTexture {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Blend mode:")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                Text(photoEditorService.textureBlendMode.title)
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: Binding(
                                get: { Double(photoEditorService.textureBlendMode.rawValue) },
                                set: { photoEditorService.applyTextureBlendMode(to: BlendMode(rawValue: Int($0)) ?? .normal) }
                            ), in: BlendMode.range, step: 1)
                                .tint(Color.textWhite.opacity(0.1))
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Text("Intensity:")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                Text("\(photoEditorService.textureIntensity)")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: $photoEditorService.textureIntensity, in: 0 ... 1)
                                .tint(Color.textWhite.opacity(0.1))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundBlackSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var slidersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                showsSettings.toggle()
            } label: {
                HStack(alignment: .center) {
                    Text("Settings")
                        .font(.h4)
                        .foregroundStyle(Color.textWhite.opacity(0.8))
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(showsSettings ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if showsSettings {
                VStack(spacing: 0) {
                    SliderView(filter: $photoEditorService.brightness)
                    SliderView(filter: $photoEditorService.contrast)
                    SliderView(filter: $photoEditorService.saturation)
                    SliderView(filter: $photoEditorService.exposure)
                    SliderView(filter: $photoEditorService.vibrance)
                    SliderView(filter: $photoEditorService.highlights)
                    SliderView(filter: $photoEditorService.shadows)
                    SliderView(filter: $photoEditorService.temperature)
                    SliderView(filter: $photoEditorService.tint)
                    SliderView(filter: $photoEditorService.gamma)
                    SliderView(filter: $photoEditorService.noiseReduction)
                    SliderView(filter: $photoEditorService.sharpness)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundBlackSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    MainView()
}
