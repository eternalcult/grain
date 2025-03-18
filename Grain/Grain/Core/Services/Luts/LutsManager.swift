import CoreImage
import Foundation

final class LutsManager: LutsManagerProtocol {
    // MARK: Properties

    private let context = CIContext()

    // MARK: Functions

    /// Parse .cube file into FilterCICubeData
    func createDataForCIColorCube(for filter: Lut) throws -> FilterCICubeData {
        guard let filterFileURL = Bundle.main.url(forResource: filter.filename, withExtension: "cube") else {
            throw LutsServiceError.couldntFindFilterFileUrl
        }
        let (dimension, rawData) = try readCubeFile(url: filterFileURL)
        return FilterCICubeData(
            id: filter.id,
            dimension: dimension,
            cubeData: convertToCubeData(dimension: dimension, rawData: rawData)
        )
    }

    /// Create CIColorCubeWithColorSpace filter from FilterCICubeData from SwiftData
    func createCIColorCube(for filter: Lut) throws -> CIColorCubeWithColorSpace {
        let filtersData = DataStorage.shared.filtersData
        if let currentFilterData = filtersData.first(where: { $0.id == filter.id }) {
            let filter = CIFilter.colorCubeWithColorSpace()
            filter.colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
            filter.cubeDimension = Float(currentFilterData.dimension)
            filter.cubeData = currentFilterData.cubeData
            return filter
        }
        // TODO: Данные для текущего фильтра отсутствуют, попробовать распарсить их в момент создания
        throw LutsServiceError.CIColorCubeFilterCreationFailed
    }

    /// Apply selected filter and apply it to selected image
    func apply(_ filter: Lut, for image: CIImage) throws -> CGImage {
        print("Apply \(filter.title) filter for image")
        let cubeFilter = try createCIColorCube(for: filter)
        cubeFilter.inputImage = image
        if let output = cubeFilter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return cgImage
        }
        throw LutsServiceError.filterApplyingFailed
    }
}

extension LutsManager {
    private func readCubeFile(url: URL) throws -> (Int, [Float]) {
        // Считываем весь текст файла
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            throw LutsServiceError.cubeFileReadingError
        }

        var dimension = 0
        var data = [Float]()

        // Разделяем файл на строки
        let lines = content.split(separator: "\n")

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            // Пропускаем комментарии и пустые строки
            if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") || trimmedLine.hasPrefix("DOMAIN_MIN") || trimmedLine
                .hasPrefix("DOMAIN_MAX") || trimmedLine.hasPrefix("TITLE")
            {
                continue
            }

            // Читаем размер LUT (например, LUT_3D_SIZE 33)
            if trimmedLine.hasPrefix("LUT_3D_SIZE") {
                if let size = Int(trimmedLine.replacingOccurrences(of: "LUT_3D_SIZE", with: "").trimmingCharacters(in: .whitespaces)) {
                    dimension = size
                }
            } else {
                // Парсим строки данных (например, "0.0 0.0 0.0")
                let components = trimmedLine.split(separator: " ").compactMap { Float($0) }
                data.append(contentsOf: components)
            }
        }

        return (dimension, data)
    }

    /// Convert .cube data into CIColorCube data
    private func convertToCubeData(dimension: Int, rawData: [Float]) -> Data {
        var cubeData = [Float]()
        let componentsPerEntry = rawData.count / (dimension * dimension * dimension) // 3 (RGB) или 4 (RGBA)

        for i in 0 ..< rawData.count / componentsPerEntry {
            let startIndex = i * componentsPerEntry
            let r = rawData[startIndex]
            let g = rawData[startIndex + 1]
            let b = rawData[startIndex + 2]
            let a = componentsPerEntry == 4 ? rawData[startIndex + 3] : 1
            cubeData.append(contentsOf: [r, g, b, a])
        }
        return cubeData.withUnsafeBufferPointer { bufferPointer -> Data in
            Data(buffer: bufferPointer)
        }
    }
}
