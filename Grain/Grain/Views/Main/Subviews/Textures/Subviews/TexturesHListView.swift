import SwiftUI

struct TexturesHListView: View {
    // MARK: SwiftUI Properties

    @Environment(MainViewModel.self) private var viewModel
    @State private var scrollToIndex: UUID?
    @State private var visibleTexturesCategory: UUID?
    @State private var visibleItems: [UUID] = []

    // MARK: Content Properties

    var body: some View {
        VStack {
            // Категории
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.texturesCategories) { category in
                        Button {
                            scrollToIndex = category.id
                        } label: {
                            var isUnderlined: Bool {
                                if let visibleTexturesCategory {
                                    return visibleTexturesCategory == category.id
                                }
                                return false
                            }
                            Text(category.title)
                                .font(.h5)
                                .underline(isUnderlined)
                                .foregroundStyle(Color.text.opacity(0.8))
                        }
                    }
                }
            }
            // Текстуры
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: .xs) {
                        RawPreviewView(isSelected: viewModel.currentTexture == nil) {
                            viewModel.removeTexture()
                        }
                        .frame(width: 100, height: 100)
                        ForEach(viewModel.texturesCategories) { category in
                            HStack(spacing: .xs) {
                                ForEach(category.textures) { texture in
                                    GeometryReader { geometry in
                                        TexturePreviewView(
                                            texture: texture,
                                            isSelected: isSelected(currentTexture: texture, selectedTexture: viewModel.currentTexture)
                                        ) {
                                            viewModel.applyTexture(texture)
                                        }
                                        .frame(width: 100, height: 100)
                                        .onChange(of: geometry.frame(in: .global)) { _, newValue in
                                            trackItemPosition(texture.id, frame: newValue)
                                        }
                                    }
                                    .frame(width: 100)
                                }
                            }
                            .id(category.id)
                        }
                    }
                    .padding(.vertical, .xs)
                }
                .scrollIndicators(.hidden)
                .onChange(of: scrollToIndex) { _, newValue in
                    if let newValue {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            proxy.scrollTo(newValue, anchor: .leading)
                        }
                        scrollToIndex = nil
                    }
                }
            }
        }
    }

    // MARK: Functions

    private func trackItemPosition(_ id: UUID, frame: CGRect) {
        let screenWidth = UIScreen.main.bounds.width
        if frame.minX < screenWidth, frame.maxX > 0 {
            if !visibleItems.contains(id) {
                visibleItems.append(id)
            }
        } else {
            if let index = visibleItems.firstIndex(of: id) {
                visibleItems.remove(at: index)
            }
        }
        selectedCategory()
    }

    private func isSelected(currentTexture: Texture, selectedTexture: Texture?) -> Bool {
        guard let selectedTexture else {
            return false
        }
        return currentTexture.id == selectedTexture.id
    }

    private func selectedCategory() {
        let selectedCategories = viewModel.texturesCategories.filter { $0.textures.contains { texture in
            visibleItems.contains(texture.id)
        }}
        visibleTexturesCategory = selectedCategories.last?.id
    }
}
