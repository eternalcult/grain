import SwiftUI

struct TexturesPreviewsView: View {
    @State private var scrollToIndex: UUID?
    @State private var visibleTexturesCategory: UUID?
    @State private var visibleItems: Set<UUID> = []

    var didTapOnPreview: ((Texture) -> Void)?


    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(texturesCategories) { category in
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
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 4) {
                            ForEach(texturesCategories) { category in
                                LazyHStack(spacing: 4) {
                                    ForEach(category.textures) { texture in
                                        LazyHStack {
                                            TexturePreviewView(texture: texture) {
                                                didTapOnPreview?(texture)
                                            }
                                        }
                                        .onAppear {
                                            visibleTexturesCategory = category.id
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
