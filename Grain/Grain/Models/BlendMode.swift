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

    static let range: ClosedRange<Double> = 0...22

    var title: String {
        switch self {
        case .normal:
            return "Normal"
        case .darken:
            return "Darken"
        case .exclusion:
            return "Exclusion"
        case .colorBurn:
            return "Color Burn"
        case .linearBurn:
            return "Linear Burn"
        case .multiply:
            return "Multipy"
        case .screen:
            return "Screen"
        case .colorDodge:
            return "Color Dodge"
        case .linearDodge:
            return "Linear Dodge"
        case .overlay:
            return "Overlay"
        case .softLight:
            return "Soft Light"
        case .vividLight:
            return "Vivid Light"
        case .linearLight:
            return "Linear Light"
        case .pinLight:
            return "Pin Light"
        case .difference:
            return "Difference"
        case .lighten:
            return "Lighten"
        case .subtract:
            return "Substract"
        case .divide:
            return "Divide"
        case .hue:
            return "Hue"
        case .saturation:
            return "Saturation"
        case .color:
            return "Color"
        case .luminosity:
            return "Luminosity"
        case .darkerColor:
            return "Darker Color"
        }
    }

    var ciFilter: (CIFilter & CICompositeOperation) {
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
