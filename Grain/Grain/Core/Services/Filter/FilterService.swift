import CoreImage
import Factory

@Observable
final class FilterService: FilterServiceProtocol {
    // MARK: Properties

    private(set) var currentFilter: Filter?

    // MARK: DI

    @ObservationIgnored @Injected(\.lutsManager) private var lutsManager

    // MARK: Computed Properties

    var hasFilter: Bool {
        currentFilter != nil
    }

    // MARK: Functions

    func prepare(to newFilter: Filter, completion: () -> Void) {
        if currentFilter?.id != newFilter.id, lutsManager.verify(newFilter) {
            currentFilter = newFilter
            completion()
        }
    }

    func clear() {
        currentFilter = nil
    }

    func applyFilterIfNeeded(to processedCiImage: CIImage) throws -> CIImage {
        guard let currentFilter else {
            return processedCiImage
        }
        return try lutsManager.apply(currentFilter, for: processedCiImage)
    }
}
