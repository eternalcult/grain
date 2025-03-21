/// Все необходимые свойства и методы необходимые PhotoEditor для работы с текстурами
protocol PhotoEditorTextures {
    /// Примененная текстура в данный момент.
    var texture: Texture? { get }
    /// Режим смешивания текстуры.
    var textureBlendMode: BlendMode { get set }
    /// Используется ли текстура в данный момент.
    var hasTexture: Bool { get }
    /// Прозрачность текстуры. Стандартное значение: 0.5.
    var textureAlpha: Float { get set }

    /// Применить текстуру
    func applyTexture(_ newTexture: Texture)
    /// Удаляет текстуру и возвращает стандартные настройки blendMode и alpha для текстуры
    func removeTexture()
}
