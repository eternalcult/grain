import CoreImage

protocol DataStorageProtocol {
    var filtersCategories: [FiltersCategory] { get }
    var texturesCategories: [TexturesCategory] { get }
    var filtersPreview: [FilterPreview] { get }
    func configureFiltersDataIfNeeded()
    func createFiltersPreviews(with image: CIImage) async
    func removePreviews()
}
