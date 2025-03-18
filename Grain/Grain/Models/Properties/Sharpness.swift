import SwiftUI

/// Резкость
struct Sharpness: ImageProperty {
    var title: LocalizedStringKey = "Sharpness"
    var range: ClosedRange<Float> = 0.4 ... 1 // Default: 0.0...1
    var defaultValue: Float = 0.4
    var current: Float = 0.4
    let formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = "inputSharpness"
}
