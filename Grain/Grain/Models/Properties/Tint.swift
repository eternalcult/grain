struct Tint: ImageProperty {
    var title: String = "Tint"
    var range: ClosedRange<Float> = -200...200 // Default: -200...200
    var defaultValue: Float = 0
    var current: Float = 0
    let formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
}
