import CoreImage

/// Отвечает за применение lut фильтров изображению
protocol FilterServiceProtocol {
    /// Текущий фильтр
    var currentFilter: Filter? { get }
    /// Применен ли в данный момент фильтр изображению
    var hasFilter: Bool { get }

    /// Обновляет currentFilter
    /// - Parameters:
    ///   - newFilter: Новый фильтр
    ///   - completion: Вызывается только если id старого и нового фильтра различались
    func prepare(to newFilter: Filter, completion: () -> Void)

    /// Применить фильтр к изображению
    /// - Parameter processedCiImage: Изображение, к которому будет применен фильтр
    /// - Returns: Если текущий фильтр не выбран, возвращает  processedCiImage без изменений
    func applyFilterIfNeeded(to processedCiImage: CIImage) throws -> CIImage
    /// Удаляет текущий фильтр
    func clear()
}
