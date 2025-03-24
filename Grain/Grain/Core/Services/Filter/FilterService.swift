import CoreImage
import Factory

// MARK: - FilterService

@Observable
final class FilterService: FilterServiceProtocol {
    // MARK: Properties

    private(set) var currentFilter: Filter?

    private let context = CIContext()

    // MARK: Computed Properties

    var hasFilter: Bool {
        currentFilter != nil
    }

    // MARK: Functions

    func createPreview(_ filter: Filter, for image: CIImage) throws -> CGImage {
        let cubeFilter = try createCIColorCube(for: filter)
        cubeFilter.inputImage = image
        if let output = cubeFilter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return cgImage
        }
        throw FilterServiceError.filterApplyingFailed
    }

    func prepare(to newFilter: Filter, completion: () -> Void) {
        if currentFilter?.id != newFilter.id {
            currentFilter = newFilter
            completion()
        }
    }

    func clear() {
        currentFilter = nil
    }

    func applyFilterIfNeeded(to processedCiImage: CIImage) throws -> CIImage {
        guard let currentFilter else {
            return processedCiImage
        }
        let cubeFilter = try createCIColorCube(for: currentFilter)
        cubeFilter.inputImage = processedCiImage
        if let output = cubeFilter.outputImage {
            return output
        }
        throw FilterServiceError.filterApplyingFailed
    }
}

private extension FilterService {
    /// Создает CoreImage фильтр для применения выбранного фильтра к изображению.
    /// - Parameter filter: Модель фильтра, для которjго нужно создать CIColoCube фильтр
    /// - Returns: возвращает настроенный CIColorCubeWithColorSpace
    func createCIColorCube(for filter: Filter) throws -> CIColorCubeWithColorSpace {
        if let fileURL = Bundle.main.url(forResource: filter.filename, withExtension: "cubedata") {
            let filterData = try Data(contentsOf: fileURL)
            let ciFilter = CIFilter.colorCubeWithColorSpace()
            ciFilter.colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
            ciFilter.cubeDimension = filter.dimension
            ciFilter.cubeData = filterData
            return ciFilter
        } else {
            throw FilterServiceError.invalidFilterFileURL
        }
    }
}
