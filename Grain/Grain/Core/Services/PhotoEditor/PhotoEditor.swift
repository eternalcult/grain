import SwiftUI

/// Методы связанные с TextureService
protocol PhotoEditorTexture {
    /// Примененная текстура в данный момент.
    var texture: Texture? { get }
    /// Режим смешивания текстуры.
    var textureBlendMode: BlendMode { get }
    /// Используется ли текстура в данный момент.
    var hasTexture: Bool { get }
    /// Прозрачность текстуры. Стандартное значение: 0.5.
    var textureAlpha: Float { get set }

    /// Применить текстуру
    func applyTexture(_ newTexture: Texture)
    /// Обновляет режим смешивания текстуры.
    /// - Parameter newBlendMode: Новый выбранный режим смешивания
    func updateTextureBlendMode(to newBlendMode: BlendMode)
    /// Удаляет текстуру и возвращает стандартные настройки blendMode и alpha для текстуры
    func removeTexture()
}

/// Все необходимые свойства и методы для реализации PhotoEditorService
protocol PhotoEditor: PhotoEditorTexture {
    /// User friendly сообщение об ошибке
    var errorMessage: String? { get set }
    /// Исходное изображение. Никак не изменяется
    var sourceImage: Image? { get }
    var sourceCiImage: CIImage? { get }
    var finalImage: Image? { get }


    // MARK: Filter

    /// Примененный в данный момент фильтрю
    var filter: Filter? { get }
    /// Применен ли фильтр в данный момент.
    var hasFilter: Bool { get }

    // MARK: Other

    /// Изображение гистограммы.
    var histogram: UIImage? { get }

    // MARK: Image Properties

    /// Есть ли измененные свойства изображения.
    var hasModifiedProperties: Bool { get }
    /// Яркость.
    var brightness: ImageProperty { get set }
    /// Контрастность.
    var contrast: ImageProperty { get set }
    /// Насыщенность.
    var saturation: ImageProperty { get set }
    /// Экспозиция.
    var exposure: ImageProperty { get set }
    /// Сочность.
    var vibrance: ImageProperty { get set }
    /// Светлые участки.
    var highlights: ImageProperty { get set }
    /// Тени.
    var shadows: ImageProperty { get set }
    /// Температура.
    var temperature: ImageProperty { get set }
    /// Оттенок.
    var tint: ImageProperty { get set }
    /// Гамма.
    var gamma: ImageProperty { get set }
    /// Уменьшение шума.
    var noiseReduction: ImageProperty { get set }
    /// Резкость.
    var sharpness: ImageProperty { get set }

    // MARK: Effects

    /// Интенсивность виньетки.
    var vignetteIntensity: ImageProperty { get set }
    /// Радиус виньетки.
    var vignetteRadius: ImageProperty { get set }
    /// Интенсивность Bloom эффекта.
    var bloomIntensity: ImageProperty { get set }
    /// Радиус Bloom эффекта.
    var bloomRadius: ImageProperty { get set }

    // MARK: Functions

    /// Обновить исходное изображение.
    /// - Parameters:
    ///   - image: Новое исходное изображение
    ///   - orientation: Ориентация изображения
    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation)

    // MARK: Filters methods

    /// Применяет выбранный фильтр.
    /// - Parameter newFilter:Новый фильтр, который необходимо применить к изображению
    func applyFilter(_ newFilter: Filter)
    /// Убрать фильтр с изображения, если это необходимо
    func removeFilterIfNeeded()

    /// Сохранить изображение в галлерею
    /// - Parameter completion: Результирующий completion
    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void)
    /// Удаляет исходное изображение и возвращает все исходные значения
    func reset()
    /// Возвращает к исходным значениям все ImageProperties
    func resetSettings()
}
