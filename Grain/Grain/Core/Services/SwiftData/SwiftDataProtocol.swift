import Foundation
import SwiftData

protocol SwiftDataProtocol {
    init(context: ModelContext)
    func insert(_ model: some PersistentModel)
    func fetch<T: PersistentModel>(
        _ modelType: T.Type,
        predicate: Predicate<T>?,
        sortDescriptors: [SortDescriptor<T>]
    ) -> [T]
    func delete(_ model: some PersistentModel)
    func saveChanges()
}

extension SwiftDataProtocol {
    func fetch<T: PersistentModel>(
        _ modelType: T.Type,
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) -> [T] {
        fetch(modelType, predicate: predicate, sortDescriptors: sortDescriptors)
    }
}
