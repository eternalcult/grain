struct Gamma: ImageProperty {
    var title: String = "Gamma"
    var range: ClosedRange<Float> = 0...2.0 // Default
    var defaultValue: Float = 1.0
    var current: Float = 1.0
}
