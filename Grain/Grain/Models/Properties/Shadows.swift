struct Shadows: ImageProperty {
    let title: String = "Shadows"
    let range: ClosedRange<Float> = -1 ... 1 // Default
    let defaultValue: Float = 0
    var current: Float = 0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
}
