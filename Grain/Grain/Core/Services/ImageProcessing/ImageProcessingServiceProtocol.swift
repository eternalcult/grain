import CoreImage

/// Отвечает за изменение стандартных настроек изображения – яркость, контрастность и т.д.
protocol ImageProcessingServiceProtocol {
    /// Есть ли измененные значения – значения у которых текущее значение отличается от дефолтного.
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
    
    /// Обновить значения у текущего изображения
    /// - Parameter processedCiImage: Изображение у которого будут изменены свойства
    /// - Returns: Возвращает CIImage?
    func updateProperties(to processedCiImage: CIImage?) -> CIImage?

    /// Возвращает к исходным значениям все ImageProperties
    func reset()
}
