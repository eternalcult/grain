
import AppCore
import PhotosUI
import SwiftUI

struct MainView: View {
    // MARK: SwiftUI Properties

    @State private var viewModel = MainViewModel()

    // MARK: Content Properties

    var headerView: some View {
        ZStack {
            Image("grain")
                .resizable()
                .frame(width: 50, height: 50)
                .opacity(0.5)
            if viewModel.finalImage != nil {
                HStack {
                    Spacer()
                    Button {
                        viewModel.saveImageToPhotoLibrary()
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
    }

    var body: some View {
        VStack(spacing: 8) {
            headerView
            if viewModel.sourceImage == nil, viewModel.finalImage == nil {
                photoPickerView

            } else {
                editorView
            }
        }
        .padding(.horizontal, 8)
        .background(Color.backgroundBlack)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.errorMessage) { _, newError in
            if newError != nil {
                viewModel.showErrorAlert = true
            }
        }
        .failureBlackAlert($viewModel.showErrorAlert, message: viewModel.errorMessage, duration: 3)
    }

    private var editorView: some View {
        if let sourceImage = viewModel.sourceImage, let finalImage = viewModel.finalImage {
            return VStack(spacing: 8) {
                VStack {
                    ZStack(alignment: .trailing) {
                        sourceImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.backgroundBlackSecondary.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        finalImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(viewModel.showsFilteredImage ? 1 : 0)
                            .onLongPressGesture {} onPressingChanged: { isPressing in
                                viewModel.showsFilteredImage = !isPressing
                            }
                    }
                    .overlay(alignment: .bottomLeading) {
                        if viewModel.showsHistogram, let histogram = viewModel.histogram {
                            Image(uiImage: histogram)
                                .resizable()
                                .opacity(0.8)
                                .frame(width: 100, height: 50)
                                .padding()
                        }
                    }
                    HStack(spacing: 0) {
                        Button {
                            viewModel.showsHistogram.toggle()
                        } label: {
                            Image(systemName: "waveform.path.ecg.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(4)
                                .tint(viewModel.showsHistogram ? Color.textBlack : Color.textWhite)
                                .background(viewModel.showsHistogram ? Color.backgroundWhiteSecondary.opacity(0.8) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .padding(4)
                        Button {
                            viewModel.closeImage()
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
                        settingsView
                        effectsView
                        texturesView
                    }
                }
                .scrollIndicators(.hidden)
            }
        } else {
            return EmptyView()
        }
    }

    private var photoPickerView: some View {
        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
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
        .onChange(of: viewModel.selectedItem) { _, _ in
            viewModel.prepareForEditing()
        }
    }

    private var filtersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsFilters.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Filters")
                                .font(.h4)
                                .foregroundStyle(Color.textWhite.opacity(0.8))
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if !viewModel.isLoadingFiltersPreviews {
                                Button {
                                    viewModel.applyRandomFilter()
                                } label: {
                                    Image(systemName: "dice")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.textWhite.opacity(0.8))
                                }
                            }
                        }
                        .padding(.trailing, 8)
                        if !viewModel.isLoadingFiltersPreviews {
                            NavigationLink {
                                GalleryView(type: .filters)
                                    .environment(viewModel)
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
                        .rotationEffect(viewModel.showsFilters ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if viewModel.showsFilters {
                if viewModel.isLoadingFiltersPreviews {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.textWhite)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 8) {
                        FiltersScrollView()
                            .environment(viewModel)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundBlackSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var settingsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsSettings.toggle()
            } label: {
                HStack(alignment: .center) {
                    HStack {
                        Text("Settings")
                            .font(.h4)
                            .foregroundStyle(Color.textWhite.opacity(0.8))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if viewModel.propertiesModified {
                            Button {
                                viewModel.resetSettings()
                            } label: {
                                Image(systemName: "arrow.trianglehead.counterclockwise")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .tint(.textWhite.opacity(0.8))
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(viewModel.showsSettings ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if viewModel.showsSettings {
                VStack(spacing: 0) {
                    SliderView(property: $viewModel.brightness)
                    SliderView(property: $viewModel.contrast)
                    SliderView(property: $viewModel.saturation)
                    SliderView(property: $viewModel.exposure)
                    SliderView(property: $viewModel.vibrance)
                    SliderView(property: $viewModel.highlights)
                    SliderView(property: $viewModel.shadows)
                    SliderView(property: $viewModel.temperature)
                    SliderView(property: $viewModel.tint)
                    SliderView(property: $viewModel.gamma)
                    SliderView(property: $viewModel.noiseReduction)
                    SliderView(property: $viewModel.sharpness)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundBlackSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var effectsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsEffects.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        Text("Effects")
                            .font(.h4)
                            .foregroundStyle(Color.textWhite.opacity(0.8))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(viewModel.showsEffects ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if viewModel.showsEffects {
                VStack(spacing: 0) {
                    DoubleSlider(
                        title: "Vignette",
                        mainProperty: $viewModel.vignetteIntensity,
                        additionalProperty: $viewModel.vignetteRadius
                    )
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
                viewModel.showsTextures.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Textures")
                                .font(.h4)
                                .foregroundStyle(Color.textWhite.opacity(0.8))
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button {
                                viewModel.applyRandomTexture()
                            } label: {
                                Image(systemName: "dice")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .tint(.textWhite.opacity(0.8))
                            }
                        }
                        .padding(.trailing, 8)
                        NavigationLink {
                            GalleryView(type: .textures)
                                .environment(viewModel)
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
                        .rotationEffect(viewModel.showsTextures ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.textWhite.opacity(0.8))
                }
            }
            if viewModel.showsTextures {
                VStack(spacing: 8) {
                    TexturesScrollView()
                        .environment(viewModel)

                    if viewModel.hasTexture {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Blend mode:")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                Text(viewModel.textureBlendMode.title)
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                Spacer()
                                NavigationLink {
                                    BlendModeView()
                                } label: {
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.textWhite.opacity(0.8))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: Binding(
                                get: { Double(viewModel.textureBlendMode.rawValue) },
                                set: { viewModel.applyTextureBlendMode(to: BlendMode(rawValue: Int($0)) ?? .normal) }
                            ), in: BlendMode.range, step: 1)
                                .tint(Color.textWhite.opacity(0.1))
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Text("Intensity:")
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                                let formattedTextureIntensity = viewModel.textureIntensity.formatValueToAnotherRange(
                                    currentMin: 0,
                                    currentMax: 1,
                                    newMin: 0,
                                    newMax: 100
                                )
                                Text(String(format: "%.0f%%", formattedTextureIntensity))
                                    .font(.h5)
                                    .foregroundStyle(Color.textWhite.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: $viewModel.textureIntensity, in: 0 ... 1)
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
}

#Preview {
    MainView()
}
