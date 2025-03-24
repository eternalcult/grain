import CoreImage

protocol TextureServiceProtocol {
    /// Примененная текстура в данный момент.
    var texture: Texture? { get }
    /// Режим смешивания текстуры.
    var blendMode: BlendMode { get }
    /// Используется ли текстура в данный момент.
    var hasTexture: Bool { get }
    /// Прозрачность текстуры. Стандартное значение: 0.5.
    var alpha: Float { get }

    /// Обновляет texutre
    /// - Parameters:
    ///   - newTexture: Новая текстура
    ///   - completion: Вызывается только если id старой и новой текстуры  различаются
    func prepare(to newTexture: Texture, completion: () -> Void)
    /// Изменяет прозрачность текстуры на новое значение
    /// - Parameter newValue: Новая alpha текстуры – 0...1
    func updateAlpha(to newValue: Float)
    /// Обновляет режим наложения текстуры
    /// - Parameter newBlendMode: Новый режим наложения
    func updateBlendMode(to newBlendMode: BlendMode)
    /// Наложение текстуры поверх выбранного изображения, с учетом выбранного режима наложения и прозрачности
    /// - Parameter processedCiImage: Изображение к которому должна быть применена текстура
    /// - Returns: При успехе  возвращает обновленный CIImage, если что-то пошло не так возвращает ошибку
    func overlayTextureIfNeeded(to processedCiImage: CIImage) throws -> CIImage
    /// Удаляет текстуру и возвращает начальные значения alpha и blendMode
    func clear()
}
