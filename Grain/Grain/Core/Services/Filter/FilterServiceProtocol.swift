import CoreImage

protocol FilterServiceProtocol {
    var currentFilter: Lut? { get }
    var hasFilter: Bool { get }
    func update(to newFilter: Lut, completion: () -> Void)
    func applyFilter(to processedCiImage: CIImage?) -> Result<CIImage, Error>
    func removeFilter()
}
