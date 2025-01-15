import Foundation
/*
 Default photo editor values
 + exposure
 - brilliance
 + highlights
 + shadows
 + contrast
 + brightness
 - black point
 + saturation
 + vibrance
 - warmth
 - tint
 - sharpness
 - definition
 - noise reduction
 - vignette
 */

struct Brightness: Filter {
    let title = "Brightness"
    let range: ClosedRange<Float> = -1...1
    let defaultValue: Float = 0
    var current: Float = 0
}
struct Contrast: Filter {
    let title: String = "Contrast"
    let range: ClosedRange<Float> = 0...4
    let defaultValue: Float = 1
    var current: Float = 1
}
struct Saturation: Filter {
    let title: String = "Saturation"
    let range: ClosedRange<Float> = 0...2
    let defaultValue: Float = 1
    var current: Float = 1
}

struct Exposure: Filter {
    let title: String = "Exposure"
    let range: ClosedRange<Float> = -10...10
    let defaultValue: Float = 0
    var current: Float = 0
}

struct Vibrance: Filter {
    let title: String = "Vibrance"
    let range: ClosedRange<Float> = -1...1
    let defaultValue: Float = 0
    var current: Float = 0
}

struct Highlights: Filter { // TODO: Check values, I'm not sure about current and range
    let title: String = "Highlights"
    let range: ClosedRange<Float> = -1...1
    let defaultValue: Float = 1
    var current: Float = 1
}

struct Shadows: Filter {
    let title: String = "Shadows"
    let range: ClosedRange<Float> = -1...1
    let defaultValue: Float = 0
    var current: Float = 0
}



/*

 3. CIFilter.gammaAdjust
     •    Power: 0.0 to 3.0 (typical)
     •    Adjusts the gamma correction curve. Lower values darken midtones, while higher values lighten midtones.

 4. CIFilter.hueAdjust
     •    Angle: -π to π (or -180° to 180° in degrees)
     •    Adjusts the image hue. Positive or negative angles shift the colors in different directions.

 5. CIFilter.sharpenLuminance
     •    Sharpness: 0.0 to 2.0
     •    Default is 0.4. Values below 0.0 soften the image, and values above 0.4 sharpen it.

 7. CIFilter.unsharpMask
     •    Radius: 0.0 to 10.0
     •    Controls the blur radius used for edge detection.
     •    Intensity: 0.0 to 2.0
     •    Strength of the sharpening effect.

 8. CIFilter.dehaze
     •    Amount: -1.0 to 1.0
     •    Default is 0.0. Negative values increase haze, while positive values remove haze.

 9. CIFilter.noiseReduction
     •    NoiseLevel: 0.0 to 1.0
     •    Default is 0.02. Higher values remove more noise.
     •    Sharpness: 0.0 to 1.0
     •    Default is 0.4. Controls the sharpness of the result after noise reduction.

 10. CIFilter.colorMatrix
     •    RVector, GVector, BVector, AVector, BiasVector:
     •    These properties are 4D vectors that modify the RGBA values of the image.
     •    Values depend on your specific use case but typically range from -1.0 to 1.0.

 General Tips:
     •    Use CIContext to render output images for better performance.
     •    Validate filter parameter ranges programmatically to avoid unpredictable results.
     •    For live adjustments (e.g., with sliders in SwiftUI), ensure slider values are mapped correctly to the filter’s parameter range.

 If you need ranges for specific filters not listed here, let me know!



 */
