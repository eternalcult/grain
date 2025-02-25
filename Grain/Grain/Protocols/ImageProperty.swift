import AppCore
import SwiftUI

// MARK: - ImageProperty

typealias ImagePropertyValue = Float

protocol ImageProperty {
    var title: LocalizedStringKey { get }
    var range: ClosedRange<ImagePropertyValue> { get }
    var defaultValue: ImagePropertyValue { get }
    var current: ImagePropertyValue { get set }
    var formatStyle: ImagePropertyValueFormattedStyle { get }
    var propertyKey: String? { get }
    var isUpdated: Bool { get }
    mutating func setToDefault()
}

extension ImageProperty {
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
}

// MARK: - ImagePropertyValueFormattedStyle

enum ImagePropertyValueFormattedStyle {
    /// -100% – 0 – 100%
    case minus100to100
    /// 0% – 100%
    case zeroTo100
    case without
}
