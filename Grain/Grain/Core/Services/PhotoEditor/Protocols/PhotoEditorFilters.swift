/// Все необходимые свойства и методы необходимые PhotoEditor для работы с фильтрами
protocol PhotoEditorFilters {
    /// Примененный в данный момент лут
    var currentFilter: Filter? { get }
    /// Применен ли лут в данный момент.
    var hasFilter: Bool { get }

    /// Применяет выбранный лут.
    /// - Parameter newLut:Новый лут,, который необходимо применить к изображению
    func applyFilter(_ newLut: Filter)
    /// Удаляет лут с изображения
    func removeFilter()
}
