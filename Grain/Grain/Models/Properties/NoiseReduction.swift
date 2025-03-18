import SwiftUI

/// Уменьшение шума
struct NoiseReduction: ImageProperty {
    var title: LocalizedStringKey = "Noise Reduction"
    var range: ClosedRange<Float> = 0.2 ... 1 // Default: 0.0...1
    var defaultValue: Float = 0.2
    var current: Float = 0.2
    let formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = "inputNoiseLevel"
}
