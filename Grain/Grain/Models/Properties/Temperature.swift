import SwiftUI

struct Temperature: ImageProperty {
    var title: LocalizedStringKey = "Temperature"
    var range: ClosedRange<Float> = 2000 ... 11000 // Default: 2000...15000
    var defaultValue: Float = 6500
    var current: Float = 6500
    let formatStyle: ImagePropertyValueFormattedStyle = .without
    let propertyKey: String? = nil
}
