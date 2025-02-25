import Foundation

struct Texture: Identifiable, Decodable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case title
        case filename
    }

    // MARK: Properties

    let id = UUID()
    let title: String
    let filename: String
}
