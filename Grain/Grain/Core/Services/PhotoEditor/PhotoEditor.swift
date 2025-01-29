import SwiftUI

protocol PhotoEditor {
    var errorMessage: String? { get set }
    var sourceImage: Image? { get }
    var sourceCiImage: CIImage? { get }
    var finalImage: Image? { get }
    var finalCiImage: CIImage? { get }

    // MARK: Texture

    var texture: Texture? { get }
    var textureBlendMode: BlendMode { get }
    var hasTexture: Bool { get }

    var textureIntensity: Float { get set }

    // MARK: Filter

    var filter: Filter? { get }
    var hasFilter: Bool { get }

    // MARK: Other

    var histogram: UIImage? { get }

    // MARK: Image Properties

    var propertiesModified: Bool { get }
    var brightness: ImageProperty { get set }
    var contrast: ImageProperty { get set }
    var saturation: ImageProperty { get set }
    var exposure: ImageProperty { get set }
    var vibrance: ImageProperty { get set }
    var highlights: ImageProperty { get set }
    var shadows: ImageProperty { get set }
    var temperature: ImageProperty { get set }
    var tint: ImageProperty { get set }
    var gamma: ImageProperty { get set }
    var noiseReduction: ImageProperty { get set }
    var sharpness: ImageProperty { get set }

    // MARK: Effects

    var vignetteIntensity: ImageProperty { get set }
    var vignetteRadius: ImageProperty { get set }

    // MARK: Functions

    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation)

    func applyTexture(_ newTexture: Texture)
    func applyTextureBlendMode(to newBlendMode: BlendMode)
    func removeTextureIfNeeded()

    func applyFilter(_ newFilter: Filter)
    func removeFilterIfNeeded()

    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void)
    func reset()
    func resetSettings()
}
