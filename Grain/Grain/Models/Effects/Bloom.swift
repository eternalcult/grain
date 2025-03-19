import SwiftUI

// MARK: - BloomIntensity

struct BloomIntensity: ImageProperty {
    var title: LocalizedStringKey = "Intensity"
    var range: ClosedRange<Float> = 0 ... 1
    var defaultValue: Float = 0
    var current: Float = 0
    var formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = nil
}

// MARK: - BloomRadius

struct BloomRadius: ImageProperty {
    var title: LocalizedStringKey = "Radius"
    var range: ClosedRange<Float> = 0 ... 100
    var defaultValue: Float = 10
    var current: Float = 1
    var formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = nil
}
