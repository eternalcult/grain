import SwiftUI

// MARK: - VignetteIntensity

struct VignetteIntensity: ImageProperty {
    var title: LocalizedStringKey = "Intensity"
    var range: ClosedRange<Float> = 0 ... 10
    var defaultValue: Float = 0
    var current: Float = 0
    var formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
    let propertyKey: String? = nil
}

// MARK: - VignetteRadius

struct VignetteRadius: ImageProperty {
    var title: LocalizedStringKey = "Radius"
    var range: ClosedRange<Float> = 0 ... 2
    var defaultValue: Float = 1
    var current: Float = 1
    var formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
    let propertyKey: String? = nil
}
