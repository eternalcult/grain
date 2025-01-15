import Foundation

struct TextureCategory: Identifiable {
    let id = UUID()
    let title: String
    let textures: [Texture]
}
