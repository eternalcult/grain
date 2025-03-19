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
 + warmth
 + tint
 + sharpness
 - definition
 + noise reduction
 + vignette
 */

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

/* All available Core Image filters

 [
 + "CIVividLightBlendMode",
 + "CIColorBlendMode",
 + "CIColorBurnBlendMode",
 + "CIColorDodgeBlendMode",
 + "CIDarkenBlendMode",
 + "CIDifferenceBlendMode",
 + "CIDivideBlendMode",
 + "CIExclusionBlendMode",
 + "CIHardLightBlendMode",
 + "CIHueBlendMode",
 + "CILightenBlendMode",
 + "CILinearBurnBlendMode",
 + "CILinearDodgeBlendMode",
 + "CILinearLightBlendMode",
 + "CILuminosityBlendMode",
 + "CIMultiplyBlendMode",
 + "CIOverlayBlendMode",
 + "CIPinLightBlendMode",
 + "CISaturationBlendMode",
 + "CIScreenBlendMode",
 + "CISubtractBlendMode",
 + "CISoftLightBlendMode",
 + "CIColorControls",
 + "CIExposureAdjust",
 + "CIVibrance",
 + "CIHighlightShadowAdjust",
 + "CITemperatureAndTint",
 + "CINoiseReduction",
 + "CIHistogramDisplayFilter",

    "CIAccordionFoldTransition",
    "CIAdditionCompositing",
    "CIAffineClamp",
    "CIAffineTile",
    "CIAffineTransform",
    "CIAreaAlphaWeightedHistogram",
    "CIAreaAverage",
    "CIAreaBoundsRed",
    "CIAreaHistogram",
    "CIAreaLogarithmicHistogram",
    "CIAreaMaximum",
    "CIAreaMaximumAlpha",
    "CIAreaMinimum",
    "CIAreaMinimumAlpha",
    "CIAreaMinMax",
    "CIAreaMinMaxRed",
    "CIAttributedTextImageGenerator",
    "CIAztecCodeGenerator",
    "CIBarcodeGenerator",
    "CIBarsSwipeTransition",
    "CIBicubicScaleTransform",
    "CIBlendWithAlphaMask",
    "CIBlendWithBlueMask",
    "CIBlendWithMask",
    "CIBlendWithRedMask",
    "CIBloom", - https://developer.apple.com/documentation/coreimage/cifilter/3228276-bloom
    "CIBlurredRectangleGenerator",
    "CIBokehBlur",
    "CIBoxBlur",
    "CIBumpDistortion",
    "CIBumpDistortionLinear",
    "CICameraCalibrationLensCorrection",
    "CICannyEdgeDetector",
    "CICheckerboardGenerator",
    "CICircleSplashDistortion",
    "CICircularScreen",
    "CICircularWrap",
    "CIClamp",
    "CICMYKHalftone",
    "CICode128BarcodeGenerator",
    "CIColorAbsoluteDifference",
    "CIColorClamp",
    "CIColorCrossPolynomial",
    "CIColorCube",
    "CIColorCubesMixedWithMask",
    "CIColorCubeWithColorSpace",
    "CIColorCurves",
    "CIColorInvert",
    "CIColorMap",
    "CIColorMatrix",
    "CIColorMonochrome",
    "CIColorPolynomial",
    "CIColorPosterize",
    "CIColorThreshold",
    "CIColorThresholdOtsu",
    "CIColumnAverage",
    "CIComicEffect",
    "CIConstantColorGenerator",
    "CIConvertLabToRGB",
    "CIConvertRGBtoLab",
    "CIConvolution3X3",
    "CIConvolution5X5",
    "CIConvolution7X7",
    "CIConvolution9Horizontal",
    "CIConvolution9Vertical",
    "CIConvolutionRGB3X3",
    "CIConvolutionRGB5X5",
    "CIConvolutionRGB7X7",
    "CIConvolutionRGB9Horizontal",
    "CIConvolutionRGB9Vertical",
    "CICopyMachineTransition",
    "CICoreMLModelFilter",
    "CICrop",
    "CICrystallize",
    "CIDepthBlurEffect",
    "CIDepthOfField", - https://developer.apple.com/documentation/coreimage/cifilter/3228308-depthoffield
    "CIDepthToDisparity",
    "CIDiscBlur",
    "CIDisintegrateWithMaskTransition",
    "CIDisparityToDepth",
    "CIDisplacementDistortion",
    "CIDissolveTransition",
    "CIDistanceGradientFromRedMask",
    "CIDither",
    "CIDocumentEnhancer",
    "CIDotScreen",
    "CIDroste",
    "CIEdgePreserveUpsampleFilter",
    "CIEdges",
    "CIEdgeWork",
    "CIEightfoldReflectedTile",
    "CIFalseColor",
    "CIFlashTransition",
    "CIFourfoldReflectedTile",
    "CIFourfoldRotatedTile",
    "CIFourfoldTranslatedTile",
    "CIGaborGradients",
    "CIGammaAdjust",
    "CIGaussianBlur",
    "CIGaussianGradient",
    "CIGlassDistortion",
    "CIGlassLozenge",
    "CIGlideReflectedTile",
    "CIGloom",
    "CIGuidedFilter",
    "CIHatchedScreen",
    "CIHeightFieldFromMask",
    "CIHexagonalPixellate",
    "CIHoleDistortion",
    "CIHueAdjust",
    "CIHueSaturationValueGradient",
    "CIKaleidoscope",
    "CIKeystoneCorrectionCombined",
    "CIKeystoneCorrectionHorizontal",
    "CIKeystoneCorrectionVertical",
    "CIKMeans",
    "CILabDeltaE",
    "CILanczosScaleTransform",
    "CILenticularHaloGenerator",
    "CILightTunnel",
    "CILinearGradient",
    "CILinearToSRGBToneCurve",
    "CILineOverlay",
    "CILineScreen",
    "CIMaskedVariableBlur",
    "CIMaskToAlpha",
    "CIMaximumComponent",
    "CIMaximumCompositing",
    "CIMaximumScaleTransform",
    "CIMedianFilter",
    "CIMeshGenerator",
    "CIMinimumComponent",
    "CIMinimumCompositing",
    "CIMix",
    "CIModTransition",
    "CIMorphologyGradient",
    "CIMorphologyMaximum",
    "CIMorphologyMinimum",
    "CIMorphologyRectangleMaximum",
    "CIMorphologyRectangleMinimum",
    "CIMotionBlur",
    "CIMultiplyCompositing",
    "CINinePartStretched",
    "CINinePartTiled",
    "CIOpTile",
    "CIPageCurlTransition",
    "CIPageCurlWithShadowTransition",
    "CIPaletteCentroid",
    "CIPalettize",
    "CIParallelogramTile",
    "CIPDF417BarcodeGenerator",
    "CIPersonSegmentation",
    "CIPerspectiveCorrection",
    "CIPerspectiveRotate",
    "CIPerspectiveTile",
    "CIPerspectiveTransform",
    "CIPerspectiveTransformWithExtent",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectMono",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CIPinchDistortion",
    "CIPixellate",
    "CIPointillize",
    "CIQRCodeGenerator",
    "CIRadialGradient",
    "CIRandomGenerator",
    "CIRippleTransition",
    "CIRoundedRectangleGenerator",
    "CIRoundedRectangleStrokeGenerator",
    "CIRowAverage",
    "CISaliencyMapFilter",
    "CISampleNearest",
    "CISepiaTone",
    "CIShadedMaterial",
    "CISharpenLuminance",
    "CISixfoldReflectedTile",
    "CISixfoldRotatedTile",
    "CISmoothLinearGradient",
    "CISobelGradients",
    "CISourceAtopCompositing",
    "CISourceInCompositing",
    "CISourceOutCompositing",
    "CISourceOverCompositing",
    "CISpotColor",
    "CISpotLight",
    "CISRGBToneCurveToLinear",
    "CIStarShineGenerator",
    "CIStraightenFilter",
    "CIStretchCrop",
    "CIStripesGenerator", - https://developer.apple.com/documentation/coreimage/cifilter/3228417-stripesgenerator
    "CISunbeamsGenerator",
    "CISwipeTransition",
    "CITextImageGenerator",
    "CIThermal",
    "CIToneCurve",
    "CIToneMapHeadroom",
    "CITorusLensDistortion",
    "CITriangleKaleidoscope",
    "CITriangleTile",
    "CITwelvefoldReflectedTile",
    "CITwirlDistortion",
    "CIUnsharpMask",
    "CIVignette",
    "CIVignetteEffect",
    "CIVortexDistortion",
    "CIWhitePointAdjust",
    "CIXRay",
    "CIZoomBlur"
 ]

 */
