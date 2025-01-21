//
//  Filter.swift
//  Grain
//
//  Created by Vlad Antonov on 13.01.2025.
//

import Foundation
import AppCore

protocol ImageProperty {
    var title: String { get }
    var range: ClosedRange<Float> { get }
    var defaultValue: Float { get }
    var current: Float { get set }
    var formatStyle: ImagePropertyValueFormattedStyle { get }
    mutating func setToDefault()
}

extension ImageProperty {
    mutating func setToDefault() {
        current = defaultValue
    }

    func formattedValue() -> String {
        switch formatStyle {
        case .minus100to100:
            let value = current.formatValueToAnotherRange(currentMin: range.lowerBound, currentMax: range.upperBound, newMin: -100, newMax: 100)
            return String(format: "%.0f%%", value)
        case .zeroTo100:
            let value = current.formatValueToAnotherRange(currentMin: range.lowerBound, currentMax: range.upperBound, newMin: 0, newMax: 100)
            return String(format: "%.0f%%", value)
        case .without:
            return "\(Int(current))"
        }
    }
}

enum ImagePropertyValueFormattedStyle {
    /// -100% – 0 – 100%
    case minus100to100
    /// 0% – 100%
    case zeroTo100
    case without
}
