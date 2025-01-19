import SwiftUI

struct FiltersPreviewsView: View {
    @Environment(PhotoEditorService.self) private var photoEditorService
    @State private var scrollToIndex: UUID?
    @State private var visibleFiltersCategory: UUID?
    @State private var visibleItems: Set<UUID> = []
    private let previewImage: CIImage
    @State private var isLoading: Bool = true

    init(previewImage: CIImage) {
        self.previewImage = previewImage
    }

    var body: some View {
        VStack {
                // Категории
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filtersCategories) { category in
                            Button {
                                scrollToIndex = category.id
                            } label: {
                                var isUnderlined: Bool {
                                    if let visibleFiltersCategory {
                                        return visibleFiltersCategory == category.id
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
                            ForEach(filtersCategories) { category in
                                LazyHStack(spacing: 4) {
                                    ForEach(category.filters) { filter in
                                        LazyHStack {
                                            if let preview = filter.preview {
                                                if let selectedFilter = photoEditorService.filter {
                                                    FilterPreviewView(
                                                        previewImage: preview,
                                                        title: filter.title,
                                                        isSelected: selectedFilter.id == filter.id
                                                    ) {
                                                        photoEditorService.applyFilter(filter)
                                                    }
                                                    .frame(width: 100, height: 100)
                                                } else {
                                                    FilterPreviewView(
                                                        previewImage: preview,
                                                        title: filter.title
                                                    ) {
                                                        photoEditorService.applyFilter(filter)
                                                    }
                                                    .frame(width: 100, height: 100)
                                                }
                                            } else {
                                                EmptyView() // TODO: Такого кейса не должно быть, но нужно подумать как его исключить полностью
                                            }
                                        }
                                        .padding(.vertical, 2)
                                        .onAppear {
                                            print("Filter item \(filter.title) onAppear!")
                                            visibleFiltersCategory = category.id
                                        }
                                        .onDisappear {
                                            print("Filter item \(filter.title) onDisappear!")
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
