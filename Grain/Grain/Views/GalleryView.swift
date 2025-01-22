import SwiftUI

struct GalleryView: View {
    let type: GalleryViewType
    @Environment(\.dismiss) private var dismiss

    enum GalleryViewType {
        case filters
        case textures
    }

    @Environment(PhotoEditorService.self) private var photoEditorService

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
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
                            if filter.preview != nil {
                                if let selectedFilter = photoEditorService.filter {
                                    FilterPreviewView(filter, shouldShowFullScreen: true, isSelected: selectedFilter.id == filter.id) {
                                        photoEditorService.applyFilter(filter)
                                    }
                                    .aspectRatio(1 / 1, contentMode: .fit)
                                } else {
                                    FilterPreviewView(filter, shouldShowFullScreen: true) {
                                        photoEditorService.applyFilter(filter)
                                    }
                                    .aspectRatio(1 / 1, contentMode: .fit)
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }

            case .textures:
                ForEach(DataStorage.shared.texturesCategories) { category in
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
                                .aspectRatio(1 / 1, contentMode: .fit)
                            } else {
                                TexturePreviewView(texture: texture) {
                                    photoEditorService.applyTexture(texture)
                                }
                                .aspectRatio(1 / 1, contentMode: .fit)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundBlack)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.backgroundBlack, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.textWhite)
                }
            }
        }
    }
}

#Preview {
    VStack {
        GalleryView(type: .filters)
        GalleryView(type: .textures)
    }
}
