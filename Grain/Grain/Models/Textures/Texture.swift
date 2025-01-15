import Foundation

struct Texture: Identifiable {
    let id = UUID()
    let title: String
    let filename: String
    let prefferedBlendMode: BlendMode
}
