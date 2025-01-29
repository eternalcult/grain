import CoreImage

protocol LutsServiceProtocol {
    func createDataForCIColorCube(for filter: Filter) throws -> FilterCICubeData
    func createCIColorCube(for filter: Filter) throws -> CIColorCubeWithColorSpace
    func apply(_ filter: Filter, for image: CIImage) throws -> CGImage
}
