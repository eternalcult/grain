import CoreImage

final class ImageProcessingService: ImageProcessingServiceProtocol {
    // MARK: Properties

    var brightness: ImageProperty = Brightness()
    var contrast: ImageProperty = Contrast()
    var saturation: ImageProperty = Saturation()
    var exposure: ImageProperty = Exposure()
    var vibrance: ImageProperty = Vibrance()
    var highlights: ImageProperty = Highlights()
    var shadows: ImageProperty = Shadows()
    var temperature: ImageProperty = Temperature()
    var tint: ImageProperty = Tint()
    var gamma: ImageProperty = Gamma()
    var noiseReduction: ImageProperty = NoiseReduction()
    var sharpness: ImageProperty = Sharpness()

    // MARK: CIFilters

    private let colorControlsFilter = CIFilter.colorControls()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private let vibranceFilter = CIFilter.vibrance()
    private let highlightShadowAdjustFilter = CIFilter.highlightShadowAdjust()
    private let temperatureAndTintFilter = CIFilter.temperatureAndTint()
    private let gammaAdjustFilter = CIFilter.gammaAdjust()
    private let noiseReductionFilter = CIFilter.noiseReduction()

    private var processedCiImage: CIImage?

    // MARK: Computed Properties

    var hasModifiedProperties: Bool {
        brightness.isUpdated || contrast.isUpdated || saturation.isUpdated || exposure.isUpdated || vibrance.isUpdated || highlights
            .isUpdated || shadows.isUpdated || temperature.isUpdated || tint.isUpdated || gamma.isUpdated || noiseReduction
            .isUpdated || sharpness.isUpdated
    }

    // MARK: Functions

    func updateProperties(to processedCiImage: CIImage?) -> CIImage? {
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

        return processedCiImage
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
    }

    private func updateProperty(_ filter: CIFilter, property: some ImageProperty) {
        guard property.isUpdated, let propertyKey = property.propertyKey else { return }
        filter.setValue(processedCiImage, forKey: kCIInputImageKey) // Устанавливаем изображение как входные данные фильтра
        filter.setValue(property.current, forKey: propertyKey) // Устанавливаем значение для фильтра
        processedCiImage = filter.outputImage
    }

    // Highlights & Shadows
    private func updateHS() {
        guard highlights.isUpdated || shadows.isUpdated else {
            return
        }
        highlightShadowAdjustFilter.inputImage = processedCiImage
        highlightShadowAdjustFilter.highlightAmount = highlights.current
        highlightShadowAdjustFilter.shadowAmount = shadows.current
        processedCiImage = highlightShadowAdjustFilter.outputImage
    }

    private func updateTemperatureAndTint() {
        guard temperature.isUpdated || tint.isUpdated else {
            return
        }
        temperatureAndTintFilter.inputImage = processedCiImage
        temperatureAndTintFilter.neutral = CIVector(x: CGFloat(temperature.defaultValue), y: 0)
        temperatureAndTintFilter.targetNeutral = CIVector(x: CGFloat(temperature.current), y: CGFloat(tint.current))
        processedCiImage = temperatureAndTintFilter.outputImage
    }
}
