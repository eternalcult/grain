import CoreImage
import Foundation
import Factory

// MARK: - LutsManager

final class LutsManager: LutsManagerProtocol {
    // MARK: Properties

    private let context = CIContext()

    // MARK: DI
    
    @ObservationIgnored @Injected(\.swiftDataService) private var swiftDataService

    // MARK: Functions

    func createDataForCIColorCube(for filter: Filter) throws -> FilterCICubeData {
        guard let filterFileURL = Bundle.main.url(forResource: filter.filename, withExtension: "cube") else {
            throw LutsManagerError.couldntFindFilterFileUrl
        }
        let (dimension, rawData) = try readCubeFile(url: filterFileURL)
        return FilterCICubeData(
            id: filter.id,
            dimension: dimension,
            cubeData: convertToCubeData(dimension: dimension, rawData: rawData)
        )
    }

    func createPreview(_ filter: Filter, for image: CIImage) throws -> CGImage {
        let cubeFilter = try createCIColorCube(for: filter)
        cubeFilter.inputImage = image
        if let output = cubeFilter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return cgImage
        }
        throw LutsManagerError.filterApplyingFailed
    }



    func apply(_ filter: Filter, for image: CIImage) throws -> CIImage {
        let cubeFilter = try createCIColorCube(for: filter)
        cubeFilter.inputImage = image
        if let output = cubeFilter.outputImage {
            return output
        }
        throw LutsManagerError.filterApplyingFailed
    }

    func verify(_ filter: Filter) -> Bool { // TODO: Handle errors
        return (try? createCIColorCube(for: filter)) != nil
    }
}

extension LutsManager {
    /// Создает CoreImage фильтр для применения выбранного фильтра к изображению.
    /// - Parameter filter: Модель фильтра, для которго нужно создать CIColoCube фильтр
    /// - Returns: возвращает настроенный CIColorCubeWithColorSpace
    private func createCIColorCube(for filter: Filter) throws -> CIColorCubeWithColorSpace {
        let filtersData = swiftDataService.fetch(FilterCICubeData.self)
        if let currentFilterData = filtersData.first(where: { $0.id == filter.id }) {
            let filter = CIFilter.colorCubeWithColorSpace()
            filter.colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
            filter.cubeDimension = Float(currentFilterData.dimension)
            filter.cubeData = currentFilterData.cubeData
            return filter
        }
        // TODO: Данные для текущего фильтра отсутствуют, попробовать распарсить их в момент создания
        throw LutsManagerError.CIColorCubeFilterCreationFailed
    }

    private func readCubeFile(url: URL) throws -> (Int, [Float]) {
        // Считываем весь текст файла
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            throw LutsManagerError.cubeFileReadingError
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
