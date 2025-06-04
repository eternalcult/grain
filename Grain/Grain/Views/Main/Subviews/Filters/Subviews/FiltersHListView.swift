import SwiftUI

struct FiltersHListView: View {
    // MARK: SwiftUI Properties

    @Environment(MainViewModel.self) private var viewModel
    @State private var scrollToIndex: UUID?
    @State private var visibleFiltersCategory: UUID?
    @State private var visibleItems = [Int]()
    @State private var isLoading: Bool = true

    // MARK: Content Properties

    var body: some View {
        VStack {
            // Категории
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.filtersCategories) { category in
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
                                .foregroundStyle(Color.text.opacity(0.8))
                        }
                    }
                }
            }
            // Фильтры
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 4) {
                        RawPreviewView(isSelected: viewModel.currentFilter == nil) {
                            viewModel.removeFilter()
                        }
                        .frame(width: 100, height: 100)
                        ForEach(viewModel.filtersCategories) { category in
                            HStack(spacing: 4) {
                                ForEach(category.filters) { filter in
                                    GeometryReader { geometry in
                                        FilterPreviewView(
                                            filter,
                                            viewModel.filtersPreview.first(where: { $0.id == filter.id })?.preview,
                                            isSelected: isSelected(currentFilter: filter, selectedFilter: viewModel.currentFilter)
                                        ) {
                                            viewModel.applyFilter(filter)
                                        }
                                        .frame(width: 100, height: 100)
                                        .onChange(of: geometry.frame(in: .global)) { _, newValue in
                                            trackItemPosition(filter.id, frame: newValue)
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

    // MARK: Functions

    private func trackItemPosition(_ id: Int, frame: CGRect) {
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

    private func isSelected(currentFilter: Filter, selectedFilter: Filter?) -> Bool {
        guard let selectedFilter else {
            return false
        }
        return currentFilter.id == selectedFilter.id
    }

    private func selectedCategory() {
        let selectedCategories = viewModel.filtersCategories.filter { $0.filters.contains { filter in
            visibleItems.contains(filter.id)
        }}
        visibleFiltersCategory = selectedCategories.last?.id
    }
}
