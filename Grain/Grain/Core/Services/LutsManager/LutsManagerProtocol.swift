import CoreImage

protocol LutsManagerProtocol {
    /// Парсит .cube файл в FilterCICubeData
    /// - Parameter filter: Модель фильтра, для которого нужно сгенерировать дату
    /// - Returns: SwiftData модель, для сохранения в БД
    func createDataForCIColorCube(for filter: Filter) throws -> FilterCICubeData
    /// Создает CoreImage фильтр для применения выбранного фильтра к изображению.
    /// - Parameter filter: Модель фильтра, для которго нужно создать CIColoCube фильтр
    /// - Returns: возвращает настроенный CIColorCubeWithColorSpace
    func createCIColorCube(for filter: Filter) throws -> CIColorCubeWithColorSpace
    /// Применение
    func apply(_ filter: Filter, for image: CIImage) throws -> CGImage
}
