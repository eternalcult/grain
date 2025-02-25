import SwiftUI

struct Contrast: ImageProperty {    
    let title: LocalizedStringKey = "Contrast"
    let range: ClosedRange<Float> = 0 ... 2 // Default: 0...4
    let defaultValue: Float = 1
    var current: Float = 1
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
    let propertyKey: String? = kCIInputContrastKey
}
