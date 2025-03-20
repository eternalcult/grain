import CoreImage
import SwiftData

final class DataStorage {
    // MARK: Static Properties

    static let shared = DataStorage()

    // MARK: Properties

    let onboardingPages: [OnboardingPage] = [ // TODO: Заменить на JSON
        .init(
            imageName: "Onboarding/onboarding1",
            title: "Welcome to Grain!",
            description: "Start enhancing your photos with easy-to-use tools and intuitive controls. Grain gives you the power to make your photos look exactly the way you envision them."
        ),
        .init(
            imageName: "Onboarding/onboarding2",
            title: "All-in-One Photo Editing",
            description: "From exposure adjustments to creative filters. Grain has everything you need to transform your photos. Enhance, perfect, and personalize every image with just a few taps!"
        ),
        .init(
            imageName: "Onboarding/onboarding3",
            title: "100% Free to Use!",
            description: "No subscriptions, no hidden fees—Grain is completely free. Enjoy full access to all our powerful photo editing tools without any cost!"
        ),
    ]

    private(set) var filtersCategories: [FiltersCategory] = []
    private(set) var texturesCategories: [TexturesCategory] = []

    var filtersPreview = [FilterPreview]()

    private let lutsManager = LutsManager()

    private var swiftDataManager: SwiftDataManager?

    // MARK: Computed Properties

    var filtersData: [FilterCICubeData] {
        swiftDataManager?.fetch(FilterCICubeData.self) ?? []
    }

    // MARK: Lifecycle

    private init() {
        do {
            filtersCategories = try loadFilters()
            texturesCategories = try loadTextures()
        } catch {
            print("ERROR", error.localizedDescription)
            // TODO: Handle error
        }

        print("Filters count:", filtersCategories.flatMap(\.filters).count)
        print("Textures count:", texturesCategories.flatMap(\.textures).count)
    }

    // MARK: Functions

    func addSwiftDataContext(_ context: ModelContext) {
        swiftDataManager = SwiftDataManager(context: context)
    }

    func configureFiltersDataIfNeeded() {
        let filtersData = filtersData
        for category in filtersCategories {
            for filter in category.filters {
                let isDataExist = filtersData.contains(where: { $0.id == filter.id })
                if !isDataExist {
                    print("\(filter.title) doesn't exist in SwiftData. Trying to create filter data")
                    if let filterData = try? lutsManager.createDataForCIColorCube(for: filter) {
                        print("Add filter data for \(filter.title)")
                        swiftDataManager?.insert(filterData)
                    }
                }
            }
        }
        swiftDataManager?.saveChanges()
    }

    func createFiltersPreviews(with image: CIImage) async {
        print("Creating previews for filters")
        let filters = filtersCategories.flatMap(\.filters)
        filtersPreview = filters.map {
            FilterPreview(
                id: $0.id,
                preview: Task.isCancelled ? nil : try? lutsManager.apply($0, for: image.downsample(scaleFactor: 0.5))
            )
        }
    }

    private func loadTextures() throws -> [TexturesCategory] {
        try JSONParser.loadFile(with: "Textures", as: [TexturesCategory].self)
    }

    private func loadFilters() throws -> [FiltersCategory] {
        try JSONParser.loadFile(with: "Filters", as: [FiltersCategory].self)
    }
}
