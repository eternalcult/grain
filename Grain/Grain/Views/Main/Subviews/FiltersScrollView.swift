import SwiftUI

struct FiltersScrollView: View {
    // MARK: SwiftUI Properties

    @Environment(PhotoEditorService.self) private var photoEditorService
    @State private var scrollToIndex: UUID?
    @State private var visibleFiltersCategory: UUID?
    @State private var visibleItems = [Int]()
    @State private var isLoading: Bool = true

    // MARK: Properties

    private let previewImage: CIImage

    // MARK: Lifecycle

    init(previewImage: CIImage) {
        self.previewImage = previewImage
    }

    // MARK: Content Properties

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
                            HStack(spacing: 4) {
                                ForEach(category.filters) { filter in
                                    GeometryReader { geometry in
                                        FilterPreviewView(
                                            filter,
                                            isSelected: isSelected(currentFilter: filter, selectedFilter: photoEditorService.filter)
                                        ) {
                                            photoEditorService.applyFilter(filter)
                                        }
                                        .frame(width: 100, height: 100)
                                        .onChange(of: geometry.frame(in: .global)) { oldValue, newValue in
                                            trackItemPosition(filter.id, frame: newValue)
                                        }
                                        .onChange(of: visibleItems) { oldValue, newValue in
                                            print(newValue)
                                        }
                                    }
                                    .frame(width: 100)
                                }
                            }
                            .id(category.id)
                        }
                    }
                    .padding(.vertical, 2)
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

    private func trackItemPosition(_ id: Int, frame: CGRect) {
        let screenWidth = UIScreen.main.bounds.width
        if frame.minX < screenWidth && frame.maxX > 0 {
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

    private func isSelected(currentFilter: Filter, selectedFilter: Filter?) -> Bool {
        guard let selectedFilter else {
            return false
        }
        return currentFilter.id == selectedFilter.id
    }

    private func selectedCategory() {
        let selectedCategories = DataStorage.shared.filtersCategories.filter { $0.filters.contains { filter in
            visibleItems.contains(filter.id)
        }}
        visibleFiltersCategory = selectedCategories.last?.id
    }
}
