import CoreImage
import Factory
import SwiftData

// MARK: - DataStorageService

@Observable final class DataStorageService: DataStorageProtocol {
    // MARK: Properties

    private(set) var filtersCategories: [FiltersCategory] = []
    private(set) var texturesCategories: [TexturesCategory] = []
    private(set) var filtersPreview = [FilterPreview]()

    // MARK: DI

    @ObservationIgnored @Injected(\.lutsManager) private var lutsManager
    @ObservationIgnored @Injected(\.swiftDataService) private var swiftDataService

    // MARK: Computed Properties

    var filtersData: [FilterCICubeData] {
        swiftDataService.fetch(FilterCICubeData.self)
    }

    // MARK: Lifecycle

    init() {
        do {
            filtersCategories = try loadFilters()
            texturesCategories = try loadTextures()
        } catch {
            print("Data storage error", error.localizedDescription) // TODO: Handle error
        }

        print("Filters count:", filtersCategories.flatMap(\.filters).count) // TODO: Logger
        print("Textures count:", texturesCategories.flatMap(\.textures).count) // TODO: Logger
    }

    // MARK: Functions

    func configureFiltersDataIfNeeded() {
        for category in filtersCategories {
            for filter in category.filters {
                let isDataExist = filtersData.contains(where: { $0.id == filter.id })
                if !isDataExist {
                    print("\(filter.title) doesn't exist in SwiftData. Trying to create filter data") // TODO: Logger
                    if let filterData = try? lutsManager.createDataForCIColorCube(for: filter) {
                        print("Add filter data for \(filter.title)") // TODO: Logger
                        swiftDataService.insert(filterData)
                    }
                }
            }
        }
        swiftDataService.saveChanges()
    }

    func createFiltersPreviews(with image: CIImage) async {
        print("Creating previews for filters") // TODO: Logger
        let filters = filtersCategories.flatMap(\.filters)
        filtersPreview = filters.map {
            FilterPreview(
                id: $0.id,
                preview: Task.isCancelled ? nil : try? lutsManager.createPreview($0, for: image.downsample(scaleFactor: 0.5))
            )
        }
    }

    func removePreviews() {
        filtersPreview.removeAll()
    }
}

private extension DataStorageService {
    func loadTextures() throws -> [TexturesCategory] {
        try JSONParser.loadFile(with: "Textures", as: [TexturesCategory].self)
    }

    func loadFilters() throws -> [FiltersCategory] {
        try JSONParser.loadFile(with: "Filters", as: [FiltersCategory].self)
    }
}
