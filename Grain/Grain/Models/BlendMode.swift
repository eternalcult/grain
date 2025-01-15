import CoreImage

enum BlendMode: String, CaseIterable {
    case normal
    case darken
    case exclusion
    case colorBurn = "Color Burn"
    case linearBurn = "Linear Burn"
    case multiply
    case screen
    case colorDodge = "Color Dodge"
    case linearDodge = "Linear Dodge (Add)"
    case overlay
    case softLight = "Soft Light"
    case vividLight = "Vivid Light"
    case linearLight = "Linear Light"
    case pinLight = "Pin Light"
    case difference
    case lighten
    case subtract
    case divide
    case hue
    case saturation
    case color
    case luminosity
    case darkerColor = "Darker Color"

    var ciFilter: (CIFilter & CICompositeOperation)? {
        switch self {
        case .normal:
            nil
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
