import Foundation
import SwiftData

final class SwiftDataService: SwiftDataProtocol {
    private let modelContext: ModelContext

    // MARK: Lifecycle

    // Initialize with a ModelContext
    init(context: ModelContext) {
        modelContext = context
    }

    // MARK: Functions

    /// Insert a new object
    func insert(_ model: some PersistentModel) {
        modelContext.insert(model)
    }

    /// Fetch objects of a specific type with an optional predicate
    func fetch<T: PersistentModel>(
        _ modelType: T.Type,
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) -> [T] {
        do {
            let fetchDescriptor = FetchDescriptor<T>(
                predicate: predicate,
                sortBy: sortDescriptors
            )
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching \(modelType): \(error)") // TODO: Handle errors
            return []
        }
    }

    /// Delete an object
    func delete(_ model: some PersistentModel) {
        modelContext.delete(model)
    }

    /// Save changes explicitly
    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error)") // TODO: Handle errors
        }
    }
}
