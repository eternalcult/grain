struct Sharpness: ImageProperty {
    var title: String = "Sharpness"
    var range: ClosedRange<Float> = 0.4...1 // Default: 0.0...1
    var defaultValue: Float = 0.4
    var current: Float = 0.4
}
