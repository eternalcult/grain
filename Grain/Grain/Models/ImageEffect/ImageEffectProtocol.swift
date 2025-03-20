protocol ImageEffectProtocol {
    /// Интенсивность эффекта
    var intensity: ImageEffectIntensityProtocol { get set }
    /// Радиус эффекта
    var radius: ImageEffectRadiusProtocol { get set }
    /// Было ли изменено значение
    var isUpdated: Bool { get }
    /// Возвращает стандартное значение свойству current
    mutating func setToDefault()
}

extension ImageEffectProtocol {
    var isUpdated: Bool {
        intensity.isUpdated || radius.isUpdated
    }
    mutating func setToDefault() {
        intensity.setToDefault()
        radius.setToDefault()
    }
}
