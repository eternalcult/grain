import CoreImage

protocol TextureServiceProtocol {
    /// Примененная текстура в данный момент.
    var texture: Texture? { get }
    /// Режим смешивания текстуры.
    var textureBlendMode: BlendMode { get }
    /// Используется ли текстура в данный момент.
    var hasTexture: Bool { get }
    /// Прозрачность текстуры. Стандартное значение: 0.5.
    var textureAlpha: Float { get }


    func update(to newTexture: Texture, completion: () -> Void)
    func updateAlpha(to newValue: Float)
    func updateTextureBlendMode(to newBlendMode: BlendMode)
    func overlayTexture(to processedCiImage: CIImage?) -> Result<CIImage, Error>
    func removeTexture()
}
