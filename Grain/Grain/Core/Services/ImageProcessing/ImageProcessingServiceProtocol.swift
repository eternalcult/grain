import CoreImage

/// Отвечает за изменение стандартных настроек изображения – яркость, контрастность и т.д.
protocol ImageProcessingServiceProtocol {
    /// Есть ли измененные значения – значения у которых текущее значение отличается от дефолтного.
    var hasModifiedProperties: Bool { get }

    /// Яркость.
    var brightness: ImagePropertyProtocol { get set }
    /// Контрастность.
    var contrast: ImagePropertyProtocol { get set }
    /// Насыщенность.
    var saturation: ImagePropertyProtocol { get set }
    /// Экспозиция.
    var exposure: ImagePropertyProtocol { get set }
    /// Сочность.
    var vibrance: ImagePropertyProtocol { get set }
    /// Светлые участки.
    var highlights: ImagePropertyProtocol { get set }
    /// Тени.
    var shadows: ImagePropertyProtocol { get set }
    /// Температура.
    var temperature: ImagePropertyProtocol { get set }
    /// Оттенок.
    var tint: ImagePropertyProtocol { get set }
    /// Гамма.
    var gamma: ImagePropertyProtocol { get set }
    /// Уменьшение шума.
    var noiseReduction: ImagePropertyProtocol { get set }
    /// Резкость.
    var sharpness: ImagePropertyProtocol { get set }

    // MARK: Effects

    /// Виньетка
    var vignette: ImageEffectProtocol { get set }
    /// Блум
    var bloom: ImageEffectProtocol { get set }

    /// Обновить значения у текущего изображения
    /// - Parameter processedCiImage: Изображение у которого будут изменены свойства
    /// - Returns: Возвращает CIImage?
    func updatePropertiesAndEffects(to processedCiImage: CIImage) throws -> CIImage

    /// Возвращает к исходным значениям все ImageEffects
    func resetEffects()
    /// Возвращает к исходным значениям все ImageProperties
    func reset()
}
