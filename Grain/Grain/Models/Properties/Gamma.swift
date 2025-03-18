import SwiftUI

/// Гамма
struct Gamma: ImageProperty {
    var title: LocalizedStringKey = "Gamma"
    var range: ClosedRange<Float> = 0 ... 2 // Default
    var defaultValue: Float = 1.0
    var current: Float = 1.0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
    let propertyKey: String? = "inputPower"
}
