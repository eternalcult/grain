import Foundation
import SwiftData

public final class SwiftDataManager { // TODO: Нужен ли вообще этот менеджер, SwiftData architecture
    // MARK: Properties

    private let modelContext: ModelContext

    // MARK: Lifecycle

    // Initialize with a ModelContext
    public init(context: ModelContext) {
        modelContext = context
    }

    // MARK: Functions

    // MARK: - Generic CRUD Operations

    /// Insert a new object
    public func insert(_ model: some PersistentModel) {
        modelContext.insert(model)
    }

    /// Fetch objects of a specific type with an optional predicate
    public func fetch<T: PersistentModel>(
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
            print("Error fetching \(modelType): \(error)")
            return []
        }
    }

    /// Delete an object
    public func delete(_ model: some PersistentModel) {
        modelContext.delete(model)
    }

    /// Save changes explicitly
    public func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}
