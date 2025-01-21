import SwiftUI

struct GalleryView: View {
    let type: GalleryViewType

    enum GalleryViewType {
        case filters
        case textures
    }

    @Environment(PhotoEditorService.self) private var photoEditorService

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            switch type {
            case .filters:
                ForEach(DataStorage.shared.filtersCategories) { category in
                    Text(category.title)
                        .font(.h1)
                        .foregroundStyle(Color.textWhite)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(category.filters) { filter in
                            if let preview = filter.preview {
                                if let selectedFilter = photoEditorService.filter {
                                    FilterPreviewView(previewImage: preview, title: filter.title, isSelected: selectedFilter.id == filter.id
                                    ) {
                                        photoEditorService.applyFilter(filter)
                                    }
                                    .aspectRatio(1/1, contentMode: .fit)
                                } else {
                                    FilterPreviewView(previewImage: preview, title: filter.title) {
                                        photoEditorService.applyFilter(filter)
                                    }
                                    .aspectRatio(1/1, contentMode: .fit)
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            case .textures:
                ForEach(texturesCategories) { category in
                    Text(category.title)
                        .font(.h1)
                        .foregroundStyle(Color.textWhite)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
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
        }
        .padding(.horizontal)
        .background(Color.backgroundBlack)
    }
}

#Preview {
    VStack {
        GalleryView(type: .filters)
        GalleryView(type: .textures)
    }
}
