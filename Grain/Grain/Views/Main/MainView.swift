
import SwiftUI
import PhotosUI

struct MainView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var editor = PhotoEditorService()

    var body: some View {
        VStack(spacing: 8) {
            Image("grain")
                .resizable()
                .frame(width: 50, height: 50)
                .opacity(0.5)
            if let filteredImage = editor.finalImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(texturesCategories) { category in
                                HStack(spacing: 8) {
                                    ForEach(category.textures) { texture in
                                        TexturePreviewView(texture: texture) {
                                            editor.applyTexture(texture)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    slidersView
                }
            } else {
                photoPickerView
            }
        }
        .padding()
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
                        self.editor.updateSourceImage(ciImage)
                    }
                }
            })
    }

    private var slidersView: some View {
        ScrollView(.vertical) {
            SliderView(filter: $editor.brightness)
            SliderView(filter: $editor.contrast)
            SliderView(filter: $editor.saturation)
            SliderView(filter: $editor.exposure)
            SliderView(filter: $editor.vibrance)
            SliderView(filter: $editor.highlights)
            SliderView(filter: $editor.shadows)
        }
    }
}

#Preview {
    MainView()
}
