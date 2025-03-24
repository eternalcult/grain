import Foundation
@testable import Grain

let mockValidFilter = Filter(
    id: 1,
    title: "Valid filter",
    desc: "Valid filter description",
    dimension: 33,
    filename: "Amelie"
)
let mockInvalidFilter = Filter(
    id: 0,
    title: "Invalid filter",
    desc: "Invalid filter description",
    dimension: 33,
    filename: "mock_filter"
)
let mockValidTexture = Texture(
    title: "Valid texture",
    filename: "Textures/GrainDust/01"
)
let mockInvalidTexture = Texture(
    title: " Invalid texture",
    filename: "mock_texture"
)
