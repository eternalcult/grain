//
//  Vignette.swift
//  Grain
//
//  Created by Vlad Antonov on 29.01.2025.
//

import Foundation

struct VignetteIntensity: ImageProperty {
    var title: String = "Intensity"
    var range: ClosedRange<Float> = 0...10
    var defaultValue: Float = 0
    var current: Float = 0
    var formatStyle: ImagePropertyValueFormattedStyle = .zeroTo100
}

struct VignetteRadius: ImageProperty {
    var title: String = "Radius"
    var range: ClosedRange<Float> = 0...2
    var defaultValue: Float = 1
    var current: Float = 1
    var formatStyle: ImagePropertyValueFormattedStyle = .minus100to100
}
