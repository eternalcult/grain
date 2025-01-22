import CoreImage
import Foundation

// TODO: createCIColorCube каждый раз парсит .cube файл и запускает луп на 35к строк, исправить
final class LutsManager {
    // MARK: Properties

    private let context = CIContext()

    // MARK: Functions

    func createDataForCIColorCube(for filter: Filter) -> FilterCICubeData? {
        if let filterFileURL = Bundle.main.url(forResource: filter.filename, withExtension: "cube") {
            do {
                let (dimension, rawData) = try readCubeFile(url: filterFileURL)
                return FilterCICubeData(
                    id: filter.id,
                    dimension: dimension,
                    cubeData: convertToCubeData(dimension: dimension, rawData: rawData)
                )
            } catch {
                print("Ошибка при чтении .cube файла: \(error)") // TODO: Handle errors
                return nil
            }
        }
        return nil
    }

    func createCIColorCube(for filter: Filter) -> CIColorCubeWithColorSpace? {
        let filtersData = DataStorage.shared.filtersData
        if let currentFilterData = filtersData.first(where: { $0.id == filter.id }) {
            let filter = CIFilter.colorCubeWithColorSpace()
            filter.colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
            filter.cubeDimension = Float(currentFilterData.dimension)
            filter.cubeData = currentFilterData.cubeData

            return filter
        } else { // Данные для текущего фильтра отсутствуют
            // TODO: Попробовать распарсить их в момент создания
            print("SwiftData doesn't have data for current filter")
        }
        return nil
    }

    func apply(_ filter: Filter, for image: CIImage) -> CGImage? {
        print("Apply \(filter.title) filter for image")
        guard let cubeFilter = createCIColorCube(for: filter) else {
            print("Can't create CIColorCube filter") // TODO: Handle errors
            return nil
        }
        cubeFilter.inputImage = image
        if let output = cubeFilter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return cgImage
        }
        return nil
    }

    private func readCubeFile(url: URL) throws -> (Int, [Float]) {
        // Считываем весь текст файла
        let content = try String(contentsOf: url, encoding: .utf8)

        var dimension = 0
        var data = [Float]()

        // Разделяем файл на строки
        let lines = content.split(separator: "\n")
        print("LUT .CUBE FILTE LINES COUNT", lines.count)

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
                    print("DIMENSION IS", size)
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
