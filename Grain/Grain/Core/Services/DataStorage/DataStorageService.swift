import CoreImage
import Factory
import os
import SwiftData

// MARK: - DataStorageService

@Observable final class DataStorageService: DataStorageProtocol {
    // MARK: Properties

    private(set) var filtersCategories: [FiltersCategory] = []
    private(set) var texturesCategories: [TexturesCategory] = []
    private(set) var filtersPreview = [FilterPreview]()

    private let logger = Logger.dataStorage

    // MARK: DI

    @ObservationIgnored @Injected(\.filterService) private var filterService

    // MARK: Lifecycle

    init() {
        do {
            filtersCategories = try loadFilters()
            texturesCategories = try loadTextures()
        } catch {
            print(error.localizedDescription) // TODO: Handle error
        }

        logger.info("Filters count: \(self.filtersCategories.flatMap(\.filters).count)")
        logger.info("Textures count: \(self.texturesCategories.flatMap(\.textures).count)")
    }

    // MARK: Functions

    func createFiltersPreviews(with image: CIImage) async {
        let filters = filtersCategories.flatMap(\.filters)
        filtersPreview = filters.map {
            FilterPreview(
                id: $0.id,
                preview: Task.isCancelled ? nil : try? filterService.createPreview($0, for: image.downsample(scaleFactor: 0.5))
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
