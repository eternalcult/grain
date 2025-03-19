import SwiftUI

/// Тени
struct Shadows: ImageProperty {
    let title: LocalizedStringKey = "Shadows"
    let range: ClosedRange<Float> = -1 ... 1 // Default
    let defaultValue: Float = 0
    var current: Float = 0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
    let propertyKey: String? = nil
}
