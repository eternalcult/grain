import CoreImage

final class FilterService: FilterServiceProtocol {
    private let lutsManager: LutsManagerProtocol
    private(set) var currentFilter: Lut?
    var hasFilter: Bool {
        currentFilter != nil
    }

    init(lutsManager: LutsManagerProtocol = LutsManager()) {
        self.lutsManager = lutsManager
    }

    func update(to newFilter: Lut, completion: () -> Void) {
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
            let lutFilter = try lutsManager.createCIColorCube(for: currentFilter)
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
