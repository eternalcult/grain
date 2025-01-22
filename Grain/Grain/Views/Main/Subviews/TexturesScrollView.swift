import SwiftUI

struct TexturesScrollView: View {
    @Environment(PhotoEditorService.self) private var photoEditorService
    @State private var scrollToIndex: UUID?
    @State private var visibleTexturesCategory: UUID?
    @State private var visibleItems: Set<UUID> = []

    var body: some View {
        VStack {
            // Категории
            ScrollView(.horizontal) {
                HStack {
                    ForEach(DataStorage.shared.texturesCategories) { category in
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
                                .foregroundStyle(Color.textWhite.opacity(0.8))
                        }
                    }
                }
            }
            // Текстуры
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 4) {
                        RawPreviewView(isSelected: photoEditorService.texture == nil) {
                            photoEditorService.removeTextureIfNeeded()
                            }
                            .frame(width: 100, height: 100)
                        ForEach(DataStorage.shared.texturesCategories) { category in
                                LazyHStack(spacing: 4) {
                                    ForEach(category.textures) { texture in
                                        LazyHStack {
                                            if let selectedTexture = photoEditorService.texture {
                                                TexturePreviewView(texture: texture, isSelected: selectedTexture.id == texture.id) {
                                                    photoEditorService.applyTexture(texture)
                                                }
                                                .frame(width: 100, height: 100)
                                            } else {
                                                TexturePreviewView(texture: texture) {
                                                    photoEditorService.applyTexture(texture)
                                                }
                                                .frame(width: 100, height: 100)
                                            }
                                        }
                                        .padding(.vertical, 2)
                                        .onAppear {
                                            print("Texture item \(texture.title) onAppear!")
                                            visibleTexturesCategory = category.id
                                        }
                                        .onDisappear {
                                            print("Texture item \(texture.title) onDisappear!")
                                        }
                                    }
                                }
                                .id(category.id)
                            }
                    }
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
}
