import SwiftUI

struct TexturesPreviewsListView: View {

    @Environment(PhotoEditorService.self) private var photoEditorService

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            ForEach(texturesCategories) { category in
                Text(category.title)
                    .font(.h1)
                    .foregroundStyle(Color.textWhite)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(category.textures) { texture in
                        if let selectedTexture = photoEditorService.texture {
                            TexturePreviewView(texture: texture, isSelected: selectedTexture.id == texture.id) {
                                photoEditorService.applyTexture(texture)
                            }
                            .aspectRatio(1/1, contentMode: .fit)
                        } else {
                            TexturePreviewView(texture: texture) {
                                photoEditorService.applyTexture(texture)
                            }
                            .aspectRatio(1/1, contentMode: .fit)
                        }

                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundBlack)
    }
}

#Preview {
    TexturesPreviewsListView()
}
