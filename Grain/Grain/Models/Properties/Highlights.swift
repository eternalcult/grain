struct Highlights: ImageProperty { // TODO: Check values, I'm not sure about current and range
    let title: String = "Highlights"
    let range: ClosedRange<Float> = -1...1
    let defaultValue: Float = 1
    var current: Float = 1
    let formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
}
