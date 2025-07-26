import SwiftUI

struct GalleryView: View {
    // MARK: SwiftUI Properties

    @Environment(MainRouter.self) private var router
    @Environment(MainViewModel.self) private var viewModel

    // MARK: Properties

    let type: GalleryViewType

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    // MARK: Content Properties

    var body: some View {
        ScrollView {
            switch type {
            case .filters:
                ForEach(viewModel.filtersCategories) { category in
                    Text(category.title)
                        .font(.h1)
                        .foregroundStyle(Color.text)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(category.filters) { filter in
                            let filterPreview = viewModel.filtersPreview.first(where: { $0.id == filter.id })?.preview
                            if let filterPreview {
                                if let selectedFilter = viewModel.currentFilter {
                                    FilterPreviewView(
                                        filter,
                                        filterPreview,
                                        shouldShowFullScreen: true,
                                        isSelected: selectedFilter.id == filter.id
                                    ) {
                                        viewModel.applyFilter(filter)
                                    }
                                    .aspectRatio(1 / 1, contentMode: .fit)
                                } else {
                                    FilterPreviewView(filter, filterPreview, shouldShowFullScreen: true) {
                                        viewModel.applyFilter(filter)
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
                ForEach(viewModel.texturesCategories) { category in
                    Text(category.title)
                        .font(.h1)
                        .foregroundStyle(Color.text)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(category.textures) { texture in
                            if let selectedTexture = viewModel.currentTexture {
                                TexturePreviewView(texture: texture, isSelected: selectedTexture.id == texture.id) {
                                    viewModel.applyTexture(texture)
                                }
                                .aspectRatio(1 / 1, contentMode: .fit)
                            } else {
                                TexturePreviewView(texture: texture) {
                                    viewModel.applyTexture(texture)
                                }
                                .aspectRatio(1 / 1, contentMode: .fit)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.popToRoot()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.text)
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
