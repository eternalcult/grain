import CoreImage

protocol FilterServiceProtocol {
    var currentFilter: Filter? { get }
    var hasFilter: Bool { get }
    func update(to newFilter: Filter, completion: () -> Void)
    func applyFilter(to processedCiImage: CIImage?) -> Result<CIImage, Error>
    func removeFilter()
}
