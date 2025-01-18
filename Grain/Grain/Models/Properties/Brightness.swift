struct Brightness: ImageProperty {
    let title = "Brightness"
    let range: ClosedRange<Float> = -0.20...0.20 // Default: -1...1
    let defaultValue: Float = 0
    var current: Float = 0
}
