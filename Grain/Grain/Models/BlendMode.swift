import CoreImage

enum BlendMode: Int, CaseIterable {
    case normal
    case darken
    case exclusion
    case colorBurn
    case linearBurn
    case multiply
    case screen
    case colorDodge
    case linearDodge
    case overlay
    case softLight
    case vividLight
    case linearLight
    case pinLight
    case difference
    case lighten
    case subtract
    case divide
    case hue
    case saturation
    case color
    case luminosity
    case darkerColor

    // MARK: Static Properties

    static let range: ClosedRange<Double> = 0 ... 22

    // MARK: Computed Properties

    var title: String {
        switch self {
        case .normal:
            "Normal"
        case .darken:
            "Darken"
        case .exclusion:
            "Exclusion"
        case .colorBurn:
            "Color Burn"
        case .linearBurn:
            "Linear Burn"
        case .multiply:
            "Multipy"
        case .screen:
            "Screen"
        case .colorDodge:
            "Color Dodge"
        case .linearDodge:
            "Linear Dodge"
        case .overlay:
            "Overlay"
        case .softLight:
            "Soft Light"
        case .vividLight:
            "Vivid Light"
        case .linearLight:
            "Linear Light"
        case .pinLight:
            "Pin Light"
        case .difference:
            "Difference"
        case .lighten:
            "Lighten"
        case .subtract:
            "Substract"
        case .divide:
            "Divide"
        case .hue:
            "Hue"
        case .saturation:
            "Saturation"
        case .color:
            "Color"
        case .luminosity:
            "Luminosity"
        case .darkerColor:
            "Darker Color"
        }
    }

    var ciFilter: CIFilter & CICompositeOperation {
        switch self {
        case .normal:
            CIFilter.sourceOverCompositing()
        case .darken:
            CIFilter.darkenBlendMode()
        case .exclusion:
            CIFilter.exclusionBlendMode()
        case .colorBurn:
            CIFilter.colorBurnBlendMode()
        case .linearBurn:
            CIFilter.linearBurnBlendMode()
        case .multiply:
            CIFilter.multiplyBlendMode()
        case .screen:
            CIFilter.screenBlendMode()
        case .colorDodge:
            CIFilter.colorDodgeBlendMode()
        case .linearDodge:
            CIFilter.linearDodgeBlendMode()
        case .overlay:
            CIFilter.overlayBlendMode()
        case .softLight:
            CIFilter.softLightBlendMode()
        case .vividLight:
            CIFilter.vividLightBlendMode()
        case .linearLight:
            CIFilter.linearLightBlendMode()
        case .pinLight:
            CIFilter.pinLightBlendMode()
        case .difference:
            CIFilter.differenceBlendMode()
        case .lighten:
            CIFilter.lightenBlendMode()
        case .subtract:
            CIFilter.subtractBlendMode()
        case .divide:
            CIFilter.divideBlendMode()
        case .hue:
            CIFilter.hueBlendMode()
        case .saturation:
            CIFilter.saturationBlendMode()
        case .color:
            CIFilter.colorBlendMode()
        case .luminosity:
            CIFilter.luminosityBlendMode()
        case .darkerColor:
            CIFilter.darkenBlendMode()
        }
    }
}
