import CoreImage
import Factory

// MARK: - ImageProcessingService

@Observable
final class ImageProcessingService: ImageProcessingServiceProtocol {
    // MARK: Properties

    var brightness: ImagePropertyProtocol
    var contrast: ImagePropertyProtocol
    var saturation: ImagePropertyProtocol
    var exposure: ImagePropertyProtocol
    var vibrance: ImagePropertyProtocol
    var highlights: ImagePropertyProtocol
    var shadows: ImagePropertyProtocol
    var temperature: ImagePropertyProtocol
    var tint: ImagePropertyProtocol
    var gamma: ImagePropertyProtocol
    var noiseReduction: ImagePropertyProtocol
    var sharpness: ImagePropertyProtocol

    // MARK: Effects

    var vignette: ImageEffectProtocol
    var bloom: ImageEffectProtocol

    // MARK: CIFilters

    private let colorControlsFilter = CIFilter.colorControls()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private let vibranceFilter = CIFilter.vibrance()
    private let highlightShadowAdjustFilter = CIFilter.highlightShadowAdjust()
    private let temperatureAndTintFilter = CIFilter.temperatureAndTint()
    private let gammaAdjustFilter = CIFilter.gammaAdjust()
    private let noiseReductionFilter = CIFilter.noiseReduction()

    // MARK: Effects

    private let vignetteFilter = CIFilter.vignette()
    private let bloomFilter = CIFilter.bloom()

    private var currentCiImage: CIImage?

    // MARK: Computed Properties

    var hasModifiedProperties: Bool {
        brightness.isUpdated || contrast.isUpdated || saturation.isUpdated || exposure.isUpdated || vibrance.isUpdated || highlights
            .isUpdated || shadows.isUpdated || temperature.isUpdated || tint.isUpdated || gamma.isUpdated || noiseReduction
            .isUpdated || sharpness.isUpdated
    }

    var hasModifiedEffects: Bool {
        vignette.isUpdated || bloom.isUpdated
    }

    // MARK: Lifecycle

    init(
        imagePropertyFactory: ImagePropertyFactoryProtocol = Container.shared.imagePropertyFactory.resolve(),
        imageEffectFactory: ImageEffectFactoryProtocol = Container.shared.imageEffectFactory.resolve()
    ) {
        // Properties
        brightness = imagePropertyFactory.makeProperty(of: .brightness)
        contrast = imagePropertyFactory.makeProperty(of: .contrast)
        saturation = imagePropertyFactory.makeProperty(of: .saturation)
        exposure = imagePropertyFactory.makeProperty(of: .exposure)
        vibrance = imagePropertyFactory.makeProperty(of: .vibrance)
        highlights = imagePropertyFactory.makeProperty(of: .highlights)
        shadows = imagePropertyFactory.makeProperty(of: .shadows)
        temperature = imagePropertyFactory.makeProperty(of: .temperature)
        tint = imagePropertyFactory.makeProperty(of: .tint)
        gamma = imagePropertyFactory.makeProperty(of: .gamma)
        noiseReduction = imagePropertyFactory.makeProperty(of: .noiseReduction)
        sharpness = imagePropertyFactory.makeProperty(of: .sharpness)
        // Effects
        vignette = imageEffectFactory.make(effect: .vignette)
        bloom = imageEffectFactory.make(effect: .bloom)
    }

    // MARK: Functions

    func updatePropertiesAndEffects(to processedCiImage: CIImage) throws
        -> CIImage
    {
        defer {
            self.currentCiImage = nil
        }
        currentCiImage = processedCiImage

        do {
            if brightness.isUpdated || contrast.isUpdated || saturation.isUpdated {
                currentCiImage = try updateColorControls()
            }

            if exposure.isUpdated {
                currentCiImage = try updateProperty(exposureAdjustFilter, property: exposure)
            }
            
            if vibrance.isUpdated {
                currentCiImage = try updateProperty(vibranceFilter, property: vibrance)
            }

            if highlights.isUpdated || shadows.isUpdated {
                currentCiImage = try updateHS()
            }
            
            if gamma.isUpdated {
                currentCiImage = try updateProperty(gammaAdjustFilter, property: gamma)
            }

            if temperature.isUpdated || tint.isUpdated {
                currentCiImage = try updateTemperatureAndTint()
            }
            
            if noiseReduction.isUpdated {
                currentCiImage = try updateProperty(noiseReductionFilter, property: noiseReduction)
            }
            
            if sharpness.isUpdated {
                currentCiImage = try updateProperty(noiseReductionFilter, property: sharpness)
            }
            
            if vignette.isUpdated {
                currentCiImage = try updateVignette()
            }
            
            if bloom.isUpdated {
                currentCiImage = try updateBloom()
            }

            if let currentCiImage {
                return currentCiImage
            } else {
                throw ImageProcessingError.currentCiImageIsMissing
            }
        } catch {
            throw error
        }
    }

    func resetEffects() {
        vignette.setToDefault()
        bloom.setToDefault()
    }

    func reset() {
        brightness.setToDefault()
        contrast.setToDefault()
        saturation.setToDefault()
        exposure.setToDefault()
        vibrance.setToDefault()
        highlights.setToDefault()
        shadows.setToDefault()
        temperature.setToDefault()
        tint.setToDefault()
        noiseReduction.setToDefault()
        sharpness.setToDefault()
        gamma.setToDefault()
        resetEffects()
    }
}

private extension ImageProcessingService {
    func updateColorControls() throws -> CIImage {
        guard let brightnessKey = brightness.propertyKey,
              let contrastKey = contrast.propertyKey,
              let saturationKey = saturation.propertyKey else {
            throw ImageProcessingError.propertyKeyIsMissing(propertyName: "One of color controls properties is missing")
        }

        colorControlsFilter.setValue(currentCiImage, forKey: kCIInputImageKey)
        colorControlsFilter.setValue(brightness.current, forKey: brightnessKey)
        colorControlsFilter.setValue(contrast.current, forKey: contrastKey)
        colorControlsFilter.setValue(saturation.current, forKey: saturationKey)

        if let outputImage = colorControlsFilter.outputImage {
            return outputImage
        } else {
            throw ImageProcessingError.cantUpdateProperty(propertyName: "ColorControls")
        }
    }

    func updateProperty(_ filter: CIFilter, property: some ImagePropertyProtocol) throws -> CIImage {
        guard let propertyKey = property.propertyKey else { throw ImageProcessingError.propertyKeyIsMissing(propertyName: property.title) }
        filter.setValue(currentCiImage, forKey: kCIInputImageKey) // Устанавливаем изображение как входные данные фильтра
        filter.setValue(property.current, forKey: propertyKey) // Устанавливаем значение для фильтра

        if let outputImage = filter.outputImage {
            return outputImage
        } else {
            throw ImageProcessingError.cantUpdateProperty(propertyName: property.title)
        }
    }

    // Highlights & Shadows
    func updateHS() throws -> CIImage {
        highlightShadowAdjustFilter.inputImage = currentCiImage
        highlightShadowAdjustFilter.highlightAmount = highlights.current
        highlightShadowAdjustFilter.shadowAmount = shadows.current

        if let output = highlightShadowAdjustFilter.outputImage {
            return output
        } else {
            throw ImageProcessingError.HSOutputIssue
        }
    }

    func updateTemperatureAndTint() throws -> CIImage {
        temperatureAndTintFilter.inputImage = currentCiImage
        temperatureAndTintFilter.neutral = CIVector(x: CGFloat(temperature.defaultValue), y: 0)
        temperatureAndTintFilter.targetNeutral = CIVector(x: CGFloat(temperature.current), y: CGFloat(tint.current))

        if let output = temperatureAndTintFilter.outputImage {
            return output
        } else {
            throw ImageProcessingError.temperatureAndTintOutputIssue
        }
    }

    func updateVignette() throws -> CIImage {
        vignetteFilter.inputImage = currentCiImage
        vignetteFilter.intensity = vignette.intensity.current
        vignetteFilter.radius = vignette.radius.current
        if let output = vignetteFilter.outputImage {
            return output
        } else {
            throw ImageProcessingError.vignetteOutputIssue
        }
    }

    func updateBloom() throws -> CIImage {
        bloomFilter.inputImage = currentCiImage
        bloomFilter.intensity = bloom.intensity.current
        bloomFilter.radius = bloom.radius.current
        if let originalExtent = currentCiImage?.extent, let croppedOutput = bloomFilter.outputImage?.cropped(to: originalExtent) {
            return croppedOutput
        } else {
            throw ImageProcessingError.bloomEffectCantBeApplied
        }
    }
}
