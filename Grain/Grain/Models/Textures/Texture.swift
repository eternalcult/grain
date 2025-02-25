import Foundation

struct Texture: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let filename: String

    enum CodingKeys: String, CodingKey {
        case title
        case filename
    }
}
