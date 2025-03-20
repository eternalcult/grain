/// Все необходимые свойства и методы необходимые PhotoEditor для работы со стандартными настройками изображения
protocol PhotoEditorImageProperties {
    /// Есть ли измененные свойства изображения.
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

    /// Возвращает к исходным значениям все ImageProperties
    func resetImageProperties()
}
