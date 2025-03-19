import SwiftUI

/// Яркость
struct Brightness: ImageProperty {
    let title: LocalizedStringKey = "Brightness"
    let range: ClosedRange<Float> = -0.20 ... 0.20 // Default: -1...1
    let defaultValue: Float = 0
    var current: Float = 0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
    let propertyKey: String? = kCIInputBrightnessKey
}
