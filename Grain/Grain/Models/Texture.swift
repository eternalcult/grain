//
//  Texture.swift
//  Grain
//
//  Created by Vlad Antonov on 13.01.2025.
//

import Foundation

struct TextureCategory: Identifiable {
    let id = UUID()
    let name: String
    let textures: [Texture]
}


struct Texture: Identifiable {
    let id = UUID()
    let name: String
    let filename: String
    let prefferedBlendMode: BlendMode
}


enum BlendMode {
    case exclusion
    case multiply
    case lighten
}

let texturesCategories: [TextureCategory] = [
    .init(name: "Grain", textures: [
        .init(name: "Grain 1", filename: "Textures/Grain/grain1", prefferedBlendMode: .exclusion),
        .init(name: "Grain 4", filename: "Textures/Grain/grain4", prefferedBlendMode: .exclusion),
        .init(name: "Grain 5", filename: "Textures/Grain/grain5", prefferedBlendMode: .exclusion),
        .init(name: "Grain 6", filename: "Textures/Grain/grain6", prefferedBlendMode: .exclusion),
        .init(name: "Grain 7", filename: "Textures/Grain/grain7", prefferedBlendMode: .multiply)
    ]),
    .init(name: "Rust", textures: [
        .init(name: "Rust 1", filename: "Textures/Rust/rust1", prefferedBlendMode: .lighten),
        .init(name: "Rust 2", filename: "Textures/Rust/rust2", prefferedBlendMode: .lighten),
        .init(name: "Rust 3", filename: "Textures/Rust/rust3", prefferedBlendMode: .lighten),
        .init(name: "Rust 4", filename: "Textures/Rust/rust4", prefferedBlendMode: .lighten),
        .init(name: "Rust 5", filename: "Textures/Rust/rust5", prefferedBlendMode: .lighten),
        .init(name: "Rust 6", filename: "Textures/Rust/rust6", prefferedBlendMode: .lighten),
        .init(name: "Rust 7", filename: "Textures/Rust/rust7", prefferedBlendMode: .lighten),
        .init(name: "Rust 8", filename: "Textures/Rust/rust8", prefferedBlendMode: .lighten),
        .init(name: "Rust 9", filename: "Textures/Rust/rust9", prefferedBlendMode: .lighten),
        .init(name: "Rust 10", filename: "Textures/Rust/rust10", prefferedBlendMode: .lighten)
    ])
]
