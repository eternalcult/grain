struct Saturation: ImageProperty {
    let title: String = "Saturation"
    let range: ClosedRange<Float> = 0 ... 2 // Default
    let defaultValue: Float = 1
    var current: Float = 1
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
}
