import SwiftUI

struct Exposure: ImageProperty {
    let title: LocalizedStringKey = "Exposure"
    let range: ClosedRange<Float> = -4 ... 4 // Default: -10...10
    let defaultValue: Float = 0
    var current: Float = 0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
}
