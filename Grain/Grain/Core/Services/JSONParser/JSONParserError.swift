import Foundation

enum JSONParserError: LocalizedError {
    case failedToFindFileInBundle(String)
    case errorDecodingJSON(String)

    // MARK: Computed Properties

    public var errorDescription: String? {
        switch self {
        case let .failedToFindFileInBundle(filename):
            "Failed to find \(filename) in the app bundle."
        case let .errorDecodingJSON(error):
            "Error decoding JSON \(error)"
        }
    }
}
