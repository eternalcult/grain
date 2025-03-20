import Foundation

enum JSONParser {
    static func loadFile<T: Decodable>(with filename: String, as type: T.Type = T.self) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONParserError.failedToFindFileInBundle(filename)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw JSONParserError.errorDecodingJSON(error.localizedDescription)
        }
    }
}



