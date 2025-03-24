import CoreImage

final class ImagePropertyFactory: ImagePropertyFactoryProtocol {
    func makeProperty(of type: ImagePropertyType) -> ImagePropertyProtocol {
        switch type {
        case .brightness:
            ImageProperty(
                title: "Brightness",
                range: -0.20 ... 0.20, // Default: -1...1
                defaultValue: 0,
                formatStyle: .minus100to100,
                propertyKey: kCIInputBrightnessKey
            )

        case .contrast:
            ImageProperty(
                title: "Contrast",
                range: 0 ... 2, // Default 0...4
                defaultValue: 1,
                formatStyle: .minus100to100,
                propertyKey: kCIInputContrastKey
            )

        case .exposure:
            ImageProperty(
                title: "Exposure",
                range: -4 ... 4, // Default -10...10
                defaultValue: 0,
                formatStyle: .minus100to100,
                propertyKey: kCIInputEVKey
            )

        case .gamma:
            ImageProperty(
                title: "Gamma", // Default
                range: 0 ... 2,
                defaultValue: 1,
                formatStyle: .minus100to100,
                propertyKey: "inputPower"
            )

        case .highlights:
            ImageProperty(
                title: "Highlights",
                range: -1 ... 1,
                defaultValue: 1,
                formatStyle: .zeroTo100,
                propertyKey: nil
            )

        case .noiseReduction:
            ImageProperty(
                title: "Noise Reduction",
                range: 0.2 ... 1, // Default
                defaultValue: 0.2,
                formatStyle: .zeroTo100,
                propertyKey: "inputNoiseLevel"
            )

        case .saturation:
            ImageProperty(
                title: "Saturation",
                range: 0 ... 2, // Default
                defaultValue: 1,
                formatStyle: .minus100to100,
                propertyKey: kCIInputSaturationKey
            )

        case .shadows:
            ImageProperty(
                title: "Shadows",
                range: -1 ... 1, // Default
                defaultValue: 0,
                formatStyle: .minus100to100,
                propertyKey: nil
            )

        case .sharpness:
            ImageProperty(
                title: "Sharpness",
                range: 0.4 ... 1, // Default: 0.0...1
                defaultValue: 0.4,
                formatStyle: .zeroTo100,
                propertyKey: "inputSharpness"
            )

        case .temperature:
            ImageProperty(
                title: "Temperature",
                range: 2000 ... 11000, // Default: 2000...15000
                defaultValue: 6500,
                formatStyle: .without,
                propertyKey: nil
            )

        case .tint:
            ImageProperty(
                title: "Tint",
                range: -200 ... 200, // Default
                defaultValue: 0,
                formatStyle: .minus100to100,
                propertyKey: nil
            )

        case .vibrance:
            ImageProperty(
                title: "Vibrance",
                range: -1 ... 1, // Default
                defaultValue: 0,
                formatStyle: .minus100to100,
                propertyKey: kCIInputAmountKey
            )
        }
    }
}
