import SwiftUI

struct FiltersScrollView: View {
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
                        ForEach(DataStorage.shared.filtersCategories) { category in
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
                // Фильтры
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 4) {
                            RawPreviewView(isSelected: photoEditorService.filter == nil) {
                                photoEditorService.removeFilterIfNeeded()
                            }
                            .frame(width: 100, height: 100)
                            ForEach(DataStorage.shared.filtersCategories) { category in
                                LazyHStack(spacing: 4) {
                                    ForEach(category.filters) { filter in
                                        LazyHStack {
                                            if filter.preview != nil {
                                                if let selectedFilter = photoEditorService.filter {
                                                    FilterPreviewView(
                                                        filter,
                                                        isSelected: selectedFilter.id == filter.id
                                                    ) {
                                                        photoEditorService.applyFilter(filter)
                                                    }
                                                    .frame(width: 100, height: 100)
                                                } else {
                                                    FilterPreviewView(filter) {
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
