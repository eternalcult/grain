import CoreImage

protocol LutsServiceProtocol {
    func createDataForCIColorCube(for filter: Lut) throws -> FilterCICubeData
    func createCIColorCube(for filter: Lut) throws -> CIColorCubeWithColorSpace
    func apply(_ filter: Lut, for image: CIImage) throws -> CGImage
}
