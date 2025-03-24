extension Double {
    /// For example: You have 0.5 value from range 0...1 and you want to show it as 50% from 0...100% range.
    func formatValueToAnotherRange(currentMin: Double, currentMax: Double, newMin: Double, newMax: Double) -> Double {
        newMin + ((self - currentMin) / (currentMax - currentMin)) * (newMax - newMin)
    }
}
