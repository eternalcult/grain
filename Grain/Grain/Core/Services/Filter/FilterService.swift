import CoreImage
import Factory

@Observable
final class FilterService: FilterServiceProtocol {
    // MARK: Properties

    private(set) var currentFilter: Filter?

    @ObservationIgnored @Injected(\.lutsManager) private var lutsManager

    // MARK: Computed Properties

    var hasFilter: Bool {
        currentFilter != nil
    }

    // MARK: Functions

    func update(to newFilter: Filter, completion: () -> Void) {
        if currentFilter?.id != newFilter.id, lutsManager.verify(newFilter) {
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
            let updatedImage = try lutsManager.apply(currentFilter, for: processedCiImage)
            return .success(updatedImage)
        } catch {
            return .failure(error)
        }
    }
}
