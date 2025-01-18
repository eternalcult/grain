struct Contrast: ImageProperty {
    let title: String = "Contrast"
    let range: ClosedRange<Float> = 0...2 // Default: 0...4
    let defaultValue: Float = 1
    var current: Float = 1
}
