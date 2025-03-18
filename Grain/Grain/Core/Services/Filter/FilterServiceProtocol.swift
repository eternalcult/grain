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
    func update(to newFilter: Filter, completion: () -> Void)

    /// Применить фильтр к изображению
    /// - Parameter processedCiImage: Изображение, к которому будет применен фильтр
    /// - Returns: При успехе возвращает обновленный CIImage или ошибку
    func applyFilter(to processedCiImage: CIImage?) -> Result<CIImage, Error>
    /// Удаляет текущий фильтр
    func removeFilter()
}
