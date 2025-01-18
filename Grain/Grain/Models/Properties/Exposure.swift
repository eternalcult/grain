struct Exposure: ImageProperty {
    let title: String = "Exposure"
    let range: ClosedRange<Float> = -4...4 // Default: -10...10
    let defaultValue: Float = 0
    var current: Float = 0
}
