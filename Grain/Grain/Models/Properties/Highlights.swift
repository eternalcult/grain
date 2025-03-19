import SwiftUI

/// Светлые участки
struct Highlights: ImageProperty {
    let title: LocalizedStringKey = "Highlights"
    let range: ClosedRange<Float> = -1 ... 1
    let defaultValue: Float = 1
    var current: Float = 1
    let formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = nil
}
