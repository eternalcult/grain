import Foundation

enum JSONParser {
    static func loadFile<T: Decodable>(with filename: String, as _: T.Type = T.self) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONParserError.failedToFindFileInBundle(filename)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONParserError.errorDecodingJSON(error.localizedDescription)
        }
    }
}
