/// Свойства и методы необходимые PhotoEditor для работы с фильтрами
protocol PhotoEditorFilter {
    /// Примененный в данный момент лут
    var currentFilter: Lut? { get }
    /// Применен ли лут в данный момент.
    var hasFilter: Bool { get }

    /// Применяет выбранный лут.
    /// - Parameter newLut:Новый лут,, который необходимо применить к изображению
    func applyFilter(_ newLut: Lut)
    /// Удаляет лут с изображения
    func removeFilter()

}
