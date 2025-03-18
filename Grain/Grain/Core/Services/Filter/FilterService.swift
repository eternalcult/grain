import CoreImage

@Observable
final class FilterService: FilterServiceProtocol {
    // MARK: Properties

    private(set) var currentFilter: Filter?

    private let lutsManager: LutsManagerProtocol

    // MARK: Computed Properties

    var hasFilter: Bool {
        currentFilter != nil
    }

    // MARK: Lifecycle

    init(lutsManager: LutsManagerProtocol = LutsManager()) {
        self.lutsManager = lutsManager
    }

    // MARK: Functions

    func update(to newFilter: Filter, completion: () -> Void) {
        if currentFilter?.id != newFilter.id {
            currentFilter = newFilter
            completion()
        }
    }

    func removeFilter() {
        currentFilter = nil
    }

    func applyFilter(to processedCiImage: CIImage?) -> Result<CIImage, Error> {
        do {
            guard let processedCiImage, let currentFilter else {
                throw PhotoEditorError.unknown // TODO: Добавить тип ошибки
            }
            let lutFilter = try lutsManager.createCIColorCube(for: currentFilter) // TODO: Можно сделать метод приватным и использовать lutsManager.apply?
            lutFilter.inputImage = processedCiImage
            if let outputImage = lutFilter.outputImage {
                return .success(outputImage)
            } else {
                throw PhotoEditorError.unknown // TODO: Добавить тип ошибки
            }
        } catch {
            return .failure(error)
        }
    }
}
