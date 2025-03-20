import Factory
import CoreImage

// MARK: - ImageProcessingService

@Observable
final class ImageProcessingService: ImageProcessingServiceProtocol {
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

    private var processedCiImage: CIImage?

    // MARK: Computed Properties

    var hasModifiedProperties: Bool {
        brightness.isUpdated || contrast.isUpdated || saturation.isUpdated || exposure.isUpdated || vibrance.isUpdated || highlights
            .isUpdated || shadows.isUpdated || temperature.isUpdated || tint.isUpdated || gamma.isUpdated || noiseReduction
            .isUpdated || sharpness.isUpdated
    }

    // MARK: Functions

    func updatePropertiesAndEffects(to processedCiImage: CIImage?) -> CIImage? { // TODO: Возвращать CIImage и выбрасывать ошибку если что-то не то
        defer {
            self.processedCiImage = nil
        }
        self.processedCiImage = processedCiImage

        updateProperty(colorControlsFilter, property: brightness)
        updateProperty(colorControlsFilter, property: contrast)
        updateProperty(colorControlsFilter, property: saturation)
        updateProperty(exposureAdjustFilter, property: exposure)
        updateProperty(vibranceFilter, property: vibrance)
        updateHS()
        updateProperty(gammaAdjustFilter, property: gamma)
        updateTemperatureAndTint()
        updateProperty(noiseReductionFilter, property: noiseReduction)
        updateProperty(noiseReductionFilter, property: sharpness)

        updateVignette()
        updateBloom()

        return self.processedCiImage
    }

    func resetEffects() { // TODO: Add reset button for effects section
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
    func updateProperty(_ filter: CIFilter, property: some ImagePropertyProtocol) { // TODO: Кастомные ошибки, сделать обработку
        guard property.isUpdated, let propertyKey = property.propertyKey else { return }
        filter.setValue(processedCiImage, forKey: kCIInputImageKey) // Устанавливаем изображение как входные данные фильтра
        filter.setValue(property.current, forKey: propertyKey) // Устанавливаем значение для фильтра
        processedCiImage = filter.outputImage
    }

    // Highlights & Shadows
    func updateHS() {
        guard highlights.isUpdated || shadows.isUpdated else {
            return
        }
        highlightShadowAdjustFilter.inputImage = processedCiImage
        highlightShadowAdjustFilter.highlightAmount = highlights.current
        highlightShadowAdjustFilter.shadowAmount = shadows.current
        processedCiImage = highlightShadowAdjustFilter.outputImage
    }

    func updateTemperatureAndTint() {
        guard temperature.isUpdated || tint.isUpdated else {
            return
        }
        temperatureAndTintFilter.inputImage = processedCiImage
        temperatureAndTintFilter.neutral = CIVector(x: CGFloat(temperature.defaultValue), y: 0)
        temperatureAndTintFilter.targetNeutral = CIVector(x: CGFloat(temperature.current), y: CGFloat(tint.current))
        processedCiImage = temperatureAndTintFilter.outputImage
    }

    func updateVignette() {
        guard vignette.isUpdated else {
            return
        }
        vignetteFilter.inputImage = processedCiImage
        vignetteFilter.intensity = vignette.intensity.current
        vignetteFilter.radius = vignette.radius.current
        processedCiImage = vignetteFilter.outputImage
    }

    func updateBloom() {
        guard bloom.isUpdated else {
            return
        }

        bloomFilter.inputImage = processedCiImage
        bloomFilter.intensity = bloom.intensity.current
        bloomFilter.radius = bloom.radius.current
        if let originalExtent = processedCiImage?.extent, let croppedOutput = bloomFilter.outputImage?.cropped(to: originalExtent) {
            processedCiImage = croppedOutput
        }
    }
}
