
import SwiftUI
import PhotosUI
import AppCore

struct MainView: View {
    @State private var photoEditorService = PhotoEditorService()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showsFilteredImage = true
    @State private var showsSettings = true
    @State private var showsTextures = false

    var body: some View {
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
//                .onAppear { // Only for testing
//                    if let uiImage = UIImage(named: "Textures/Grain/grain1"),
//                       let cgImage = uiImage.cgImage {
//                        self.editor.updateSourceImage(CIImage(cgImage: cgImage))
//                    }
//                }
            if let sourceImage = photoEditorService.sourceImage, let filteredImage = photoEditorService.finalImage {
                ZStack {
                    sourceImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.backgroundBlackSecondary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .background(.green)
                    filteredImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.backgroundBlackSecondary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(showsFilteredImage ? 1 : 0)
                        .onLongPressGesture { } onPressingChanged: { isPressing in
                            showsFilteredImage = !isPressing
                        }

                }
                ScrollView(.vertical) {
                    VStack(spacing: 8) {
                        slidersView
                        texturesView
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                photoPickerView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.backgroundBlack)
    }

    private var photoPickerView: some View {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Rectangle()
                    .fill(.clear)
                    .overlay(alignment: .center) {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tint(.white.opacity(0.5))
                            .frame(width: 100, height: 100)
                    }
            }
            .onChange(of: selectedItem, { _, newValue in
                guard let newValue else { return }
                Task {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let ciImage = CIImage(data: data) {
                        self.photoEditorService.updateSourceImage(ciImage)
                    }
                }
            })
    }

    @State var selectedBlendMode: BlendMode = .exclusion

    private var texturesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                showsTextures.toggle()
            } label: {
                HStack {
                    Text("Textures")
                        .font(.h4)
                        .foregroundStyle(Color.textWhite.opacity(0.8))
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                    TexturesPreviewsView() { selectedTexture in
                        selectedBlendMode = selectedTexture.prefferedBlendMode
                        photoEditorService.applyTexture(selectedTexture)
                    }

                    if photoEditorService.hasTexture {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Blend mode:")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                Text(selectedBlendMode.title)
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: Binding(
                                get: { Double(selectedBlendMode.rawValue) },
                                set: { selectedBlendMode = BlendMode(rawValue: Int($0)) ?? .normal }
                            ), in: BlendMode.range, step: 1)
                            .tint(Color.textWhite.opacity(0.1))
                            .onChange(of: selectedBlendMode) { _, newValue in
                                photoEditorService.changeTextureBlendMode(to: selectedBlendMode)
                            }
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
                            Slider(value: $photoEditorService.textureIntensity, in: 0...1)
                            .tint(Color.textWhite.opacity(0.1))
                            .onChange(of: selectedBlendMode) { _, newValue in
                                photoEditorService.changeTextureBlendMode(to: selectedBlendMode)
                            }
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
                HStack {
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
