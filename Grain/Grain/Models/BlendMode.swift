import CoreImage
import SwiftUI

/// Режим смешивания текстур
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

    /// Название выбранного режима смешивания
    var title: LocalizedStringKey {
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

    /// Подробное описание выбранного режима смешивания
    var description: LocalizedStringKey {
        switch self {
        case .normal:
            "Edits or paints each pixel to make it the result color. This is the default mode. (Normal mode is called Threshold when you’re working with a bitmapped or indexed-color image.)"
        case .darken:
            "Looks at the color information in each channel and selects the base or blend color—whichever is darker—as the result color. Pixels lighter than the blend color are replaced, and pixels darker than the blend color do not change."
        case .exclusion:
            "Creates an effect similar to but lower in contrast than the Difference mode. Blending with white inverts the base color values. Blending with black produces no change."
        case .colorBurn:
            "Looks at the color information in each channel and darkens the base color to reflect the blend color by increasing the contrast between the two. Blending with white produces no change."
        case .linearBurn:
            "Looks at the color information in each channel and darkens the base color to reflect the blend color by decreasing the brightness. Blending with white produces no change."
        case .multiply:
            "Looks at the color information in each channel and multiplies the base color by the blend color. The result color is always a darker color. Multiplying any color with black produces black. Multiplying any color with white leaves the color unchanged. When you’re painting with a color other than black or white, successive strokes with a painting tool produce progressively darker colors. The effect is similar to drawing on the image with multiple marking pens."
        case .screen:
            "Looks at each channel’s color information and multiplies the inverse of the blend and base colors. The result color is always a lighter color. Screening with black leaves the color unchanged. Screening with white produces white. The effect is similar to projecting multiple photographic slides on top of each other."
        case .colorDodge:
            "Looks at the color information in each channel and brightens the base color to reflect the blend color by decreasing contrast between the two. Blending with black produces no change."
        case .linearDodge:
            "Looks at the color information in each channel and brightens the base color to reflect the blend color by increasing the brightness. Blending with black produces no change."
        case .overlay:
            "Multiplies or screens the colors, depending on the base color. Patterns or colors overlay the existing pixels while preserving the highlights and shadows of the base color. The base color is not replaced, but mixed with the blend color to reflect the lightness or darkness of the original color."
        case .softLight:
            "Darkens or lightens the colors, depending on the blend color. The effect is similar to shining a diffused spotlight on the image. If the blend color (light source) is lighter than 50% gray, the image is lightened as if it were dodged. If the blend color is darker than 50% gray, the image is darkened as if it were burned in. Painting with pure black or white produces a distinctly darker or lighter area, but does not result in pure black or white."
        case .vividLight:
            "Burns or dodges the colors by increasing or decreasing the contrast, depending on the blend color. If the blend color (light source) is lighter than 50% gray, the image is lightened by decreasing the contrast. If the blend color is darker than 50% gray, the image is darkened by increasing the contrast."
        case .linearLight:
            "Burns or dodges the colors by decreasing or increasing the brightness, depending on the blend color. If the blend color (light source) is lighter than 50% gray, the image is lightened by increasing the brightness. If the blend color is darker than 50% gray, the image is darkened by decreasing the brightness."
        case .pinLight:
            "Replaces the colors, depending on the blend color. If the blend color (light source) is lighter than 50% gray, pixels darker than the blend color are replaced, and pixels lighter than the blend color do not change. If the blend color is darker than 50% gray, pixels lighter than the blend color are replaced, and pixels darker than the blend color do not change. This is useful for adding special effects to an image."
        case .difference:
            "Looks at the color information in each channel and subtracts either the blend color from the base color or the base color from the blend color, depending on which has the greater brightness value. Blending with white inverts the base color values; blending with black produces no change."
        case .lighten:
            "Looks at the color information in each channel and selects the base or blend color—whichever is lighter—as the result color. Pixels darker than the blend color are replaced, and pixels lighter than the blend color do not change."
        case .subtract:
            "Looks at the color information in each channel and subtracts the blend color from the base color. In 8- and 16-bit images, any resulting negative values are clipped to zero."
        case .divide:
            "Looks at the color information in each channel and divides the blend color from the base color."
        case .hue:
            "Creates a result color with the luminance and saturation of the base color and the hue of the blend color."
        case .saturation:
            "Creates a result color with the luminance and hue of the base color and the saturation of the blend color. Painting with this mode in an area with no (0) saturation (gray) causes no change."
        case .color:
            "Creates a result color with the luminance of the base color and the hue and saturation of the blend color. This preserves the gray levels in the image and is useful for coloring monochrome images and for tinting color images."
        case .luminosity:
            "Creates a result color with the hue and saturation of the base color and the luminance of the blend color. This mode creates the inverse effect of Color mode."
        case .darkerColor:
            "Compares the total of all channel values for the blend and base color and displays the lower value color. Darker Color does not produce a third color, which can result from the Darken blend, because it chooses the lowest channel values from both the base and the blend color to create the result color."
        }
    }

    /// CIFilter для выбранного режима смешивания
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
