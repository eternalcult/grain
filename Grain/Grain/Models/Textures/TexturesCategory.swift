import Foundation

struct TexturesCategory: Identifiable, Decodable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case title
        case textures
    }

    // MARK: Properties

    let id = UUID()
    let title: String
    let textures: [Texture]
}
