import Foundation
import CoreImage

// TODO: createCIColorCube каждый раз парсит .cube файл и запускает луп на 35к строк, исправить
final class LutsManager {
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
            if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") || trimmedLine.hasPrefix("DOMAIN_MIN") || trimmedLine.hasPrefix("DOMAIN_MAX"){
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

    private func convertToCubeData(dimension: Int, rawData: [Float]) -> Data {
        var cubeData = [Float]()
        let componentsPerEntry = rawData.count / (dimension * dimension * dimension) // 3 (RGB) или 4 (RGBA)

        for i in 0..<rawData.count / componentsPerEntry {
            let startIndex = i * componentsPerEntry
            let r = rawData[startIndex]
            let g = rawData[startIndex + 1]
            let b = rawData[startIndex + 2]
            let a = componentsPerEntry == 4 ? rawData[startIndex + 3] : 1.0 // Если альфа отсутствует, задаем 1.0
            cubeData.append(contentsOf: [r, g, b, a])
        }

        return Data(buffer: UnsafeBufferPointer(start: cubeData, count: cubeData.count))
    }

    func createCIColorCube(for filter: Filter) -> CIColorCube? {
        if let filterFileURL = Bundle.main.url(forResource: filter.filename, withExtension: "cube") {
            do {
                // Шаг 1: Читаем файл .cube
                let (dimension, rawData) = try readCubeFile(url: filterFileURL)

                // Шаг 2: Преобразуем данные в формат cubeData
                let cubeData = convertToCubeData(dimension: dimension, rawData: rawData)

                // Шаг 3: Создаем CIColorCube фильтр
                let filter = CIFilter.colorCube()
                filter.setValue(dimension, forKey: "inputCubeDimension")
                filter.setValue(cubeData, forKey: "inputCubeData")

                return filter
            } catch {
                print("Ошибка при чтении .cube файла: \(error)") // TODO: Handle errors
                fatalError()
            }
        } else {
            print("File not found in the main bundle.") // TODO: Handle errors
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

    private let context = CIContext()
}
