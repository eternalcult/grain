import AppCore
import SwiftData
import CoreImage

final class DataStorage {
    private let lutsManager = LutsManager()

    static let shared = DataStorage()

    private var swiftDataManager: SwiftDataManager?

    private init() {}

    func addSwiftDataContext(_ context: ModelContext) {
        swiftDataManager = SwiftDataManager(context: context)
    }

    var filtersData: [FilterCICubeData] {
        swiftDataManager?.fetch(FilterCICubeData.self) ?? []
    }

    func configureFiltersDataIfNeeded() {
        let filtersData = filtersData
        print("FiltersData is", filtersData)
        filtersCategories.forEach { category in
            category.filters.forEach { filter in
                if !filtersData.contains(where: { $0.id == filter.id }) {
                    print("\(filter.title) doesn't exist in SwiftData. Trying to create filter data")
                    if let filterData = lutsManager.createDataForCIColorCube(for: filter) {
                        swiftDataManager?.insert(filterData)
                        print("Add filter data for \(filter.title)")
                    } else {
                        print("Can't create data for CIColorCube")
                    }
                } else {
                    print("Filter \(filter.title) exists in SwiftData")
                }
            }
        }
        swiftDataManager?.saveChanges()
    }

    func updateFiltersPreviews(with image: CIImage) async { // TODO: Blocking UI
        filtersCategories = filtersCategories.map { category in
            print("Processing category: \(category.title)")
            let updatedFilters = category.filters.map { filter in
                print("Processing generate filter preview: \(filter.title)")
                return Filter(
                    id: filter.id,
                    title: filter.title,
                    filename: filter.filename,
                    preview: lutsManager.apply(filter, for: image.downsample()))
            }
            return FilterCategory(title: category.title, desc: category.desc, filters: updatedFilters)
        }
    }


    private(set) var filtersCategories: [FilterCategory] = [
        .init(title: "Film Emulation", desc: "", filters: [
            .init(id: 1, title: "Polatroid 600", filename: "Polaroid 600"),
            .init(id: 2, title: "Fujix Astia 100F", filename: "Fuji Astia 100F"),
            .init(id: 3, title: "Fujix Eterna 3513", filename: "Fuji Eterna 3513"),
            .init(id: 4, title: "Fujix Eterna 8563", filename: "Fuji Eterna 8563"),
            .init(id: 5, title: "Fujix Provia 100F", filename: "Fuji Provia 100F"),
            .init(id: 6, title: "Fujix Sensia 100", filename: "Fuji Sensia 100"),
            .init(id: 7, title: "Fujix Superia Xtra 400", filename: "Fuji Superia Xtra 400"),
            .init(id: 8, title: "Fujix Vivid 8543", filename: "Fuji Vivid 8543"),
            .init(id: 9, title: "Kodex Ektachrome 64", filename: "Kodak Ektachrome 64"),
            .init(id: 10, title: "Kodex Professional Portra 400", filename: "Kodak Professional Portra 400"),
            .init(id: 11, title: "Kodex Vision 2383", filename: "Kodak Vision 2383"),
            .init(id: 12, title: "LLP Tetrachrome 400", filename: "LPP Tetrachrome 400"),
            .init(id: 13, title: "Afga Portrait XPS 160", filename: "Agfa Portrait XPS 160")
        ]),
        .init(title: "Cinema", desc: "", filters: [
            .init(id: 14, title: "Blade Runner 2049", filename: "CINECOLOR_BLADE_RUNNER_2049")
        ])
    ]
}
