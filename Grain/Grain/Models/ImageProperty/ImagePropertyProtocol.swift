import SwiftUI

// MARK: - ImagePropertyProtocol
/// Стандартная настройка изображения – яркость, контрастность и т.д
protocol ImagePropertyProtocol {
    /// Название
    var title: LocalizedStringKey { get }
    /// Диапазон доступных значений
    var range: ClosedRange<ImagePropertyValue> { get }
    /// Шаг изменения значения. Необходимо для оптимизации перерисовки View при изменении значения через слайдер
    var step: Float { get }
    /// Стандартное значение
    var defaultValue: ImagePropertyValue { get }
    /// Текущее значение
    var current: ImagePropertyValue { get set }
    /// Стиль отображения - от 0 до 100%, от -100% до 100% или без форматирования
    var formatStyle: ImagePropertyFormatStyle { get }
    /// Ключ необходходимый для указания значения CIFilter
    var propertyKey: String? { get }
    /// Было ли изменено значение
    var isUpdated: Bool { get }
    /// Возвращает стандартное значение свойству current
    mutating func setToDefault()
}

extension ImagePropertyProtocol {
    mutating func setToDefault() {
        current = defaultValue
    }

    func formattedValue() -> String {
        switch formatStyle {
        case .minus100to100:
            let value = current.formatValueToAnotherRange(
                currentMin: range.lowerBound,
                currentMax: range.upperBound,
                newMin: -100,
                newMax: 100
            )
            return String(format: "%.0f%%", value)

        case .zeroTo100:
            let value = current.formatValueToAnotherRange(
                currentMin: range.lowerBound,
                currentMax: range.upperBound,
                newMin: 0,
                newMax: 100
            )
            return String(format: "%.0f%%", value)

        case .without:
            return "\(Int(current))"
        }
    }

    var isUpdated: Bool {
        current != defaultValue
    }

    var step: Float {
        switch formatStyle {
        case .minus100to100:
            (range.upperBound - range.lowerBound) / 200
        case .zeroTo100:
            (range.upperBound - range.lowerBound) / 100
        case .without:
            1
        }
    }
}
