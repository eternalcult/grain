import Foundation

struct TexturesCategory: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let textures: [Texture]

    enum CodingKeys: String, CodingKey {
        case title
        case textures
    }
}
