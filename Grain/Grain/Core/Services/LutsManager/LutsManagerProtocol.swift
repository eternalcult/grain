import CoreImage

protocol LutsManagerProtocol {
    /// Парсит .cube файл в FilterCICubeData
    /// - Parameter filter: Модель фильтра, для которого нужно сгенерировать дату
    /// - Returns: SwiftData модель, для сохранения в БД
    func createDataForCIColorCube(for filter: Filter) throws -> FilterCICubeData

    func verify(_ filter: Filter) -> Bool

    func createPreview(_ filter: Filter, for image: CIImage) throws -> CGImage
    /// Применение
    func apply(_ filter: Filter, for image: CIImage) throws -> CIImage
}
