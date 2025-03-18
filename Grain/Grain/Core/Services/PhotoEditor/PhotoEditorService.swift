import CoreImage
import CoreImage.CIFilterBuiltins
import FirebaseCrashlytics
import Photos
import SwiftUI

// MARK: - PhotoEditorService

@Observable
final class PhotoEditorService: PhotoEditor {
    // MARK: Properties

    var errorMessage: String?
    private(set) var sourceImage: Image?
    private(set) var sourceCiImage: CIImage?
    private(set) var finalImage: Image?

    // MARK: Textures

    private let textureService: TextureService = TextureServiceImp() // TODO: DI

    var texture: Texture? {
        get {
            textureService.texture
        }
        set {
            if let newValue {
                textureService.updateTexture(to: newValue) { isUpdated in
                    if isUpdated {
                        updateImage()
                    }
                }
            }
        }
    }

    var textureBlendMode: BlendMode {
        get {
            textureService.textureBlendMode
        }
        set {
            textureService.updateTextureBlendMode(to: newValue)
        }
    }

    var hasTexture: Bool {
        textureService.hasTexture
    }

    func updateTextureBlendMode(to newBlendMode: BlendMode) {
        textureService.updateTextureBlendMode(to: newBlendMode)
        updateImage()
    }
    func applyTexture(_ newTexture: Texture) {
        textureService.updateTexture(to: newTexture) { isUpdated in
            if isUpdated {
                updateImage()
            }
        }
    }
    func removeTexture() {
        textureService.clear()
        updateImage()
    }
    var textureAlpha: Float {
        get {
            textureService.textureAlpha
        }
        set {
            textureService.updateAlpha(to: newValue)
            updateImage()
        }
    }
    // MARK: Filter

    private(set) var filter: Filter?

    private(set) var histogram: UIImage?

    private let lutsService: LutsServiceProtocol

    private var processedCiImage: CIImage?
    private var sourceImageOrientation: UIImage.Orientation?

    // MARK: CIFilters

    private let colorControlsFilter = CIFilter.colorControls()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private let vibranceFilter = CIFilter.vibrance()
    private let highlightShadowAdjustFilter = CIFilter.highlightShadowAdjust()
    private let temperatureAndTintFilter = CIFilter.temperatureAndTint()
    private let gammaAdjustFilter = CIFilter.gammaAdjust()
    private let noiseReductionFilter = CIFilter.noiseReduction()
    private let vignetteFilter = CIFilter.vignette()
    private let bloomFilter = CIFilter.bloom()

    private let context = CIContext() // TODO: Настроить CIContext

    // MARK: Computed Properties

    var hasModifiedProperties: Bool {
        brightness.isUpdated || contrast.isUpdated || saturation.isUpdated || exposure.isUpdated || vibrance.isUpdated || highlights
            .isUpdated || shadows.isUpdated || temperature.isUpdated || tint.isUpdated || gamma.isUpdated || noiseReduction
            .isUpdated || sharpness.isUpdated
    }

    var brightness: ImageProperty = Brightness() {
        didSet {
            updateImage()
        }
    }

    var contrast: ImageProperty = Contrast() {
        didSet {
            updateImage()
        }
    }

    var saturation: ImageProperty = Saturation() {
        didSet {
            updateImage()
        }
    }

    var exposure: ImageProperty = Exposure() {
        didSet {
            updateImage()
        }
    }

    var vibrance: ImageProperty = Vibrance() {
        didSet {
            updateImage()
        }
    }

    var highlights: ImageProperty = Highlights() {
        didSet {
            updateImage()
        }
    }

    var shadows: ImageProperty = Shadows() {
        didSet {
            updateImage()
        }
    }

    var temperature: ImageProperty = Temperature() {
        didSet {
            updateImage()
        }
    }

    var tint: ImageProperty = Tint() {
        didSet {
            updateImage()
        }
    }

    var gamma: ImageProperty = Gamma() {
        didSet {
            updateImage()
        }
    }

    var noiseReduction: ImageProperty = NoiseReduction() {
        didSet {
            updateImage()
        }
    }

    var sharpness: ImageProperty = Sharpness() {
        didSet {
            updateImage()
        }
    }

    // MARK: Effects

    var vignetteIntensity: ImageProperty = VignetteIntensity() { // TODO: Create ImageEffect protocol
        didSet {
            updateImage()
        }
    }

    var vignetteRadius: ImageProperty = VignetteRadius() { // TODO: Create ImageEffect protocol
        didSet {
            updateImage()
        }
    }

    var bloomIntensity: ImageProperty = BloomIntensity() { // TODO: Create ImageEffect protocol
        didSet {
            updateImage()
        }
    }
    var bloomRadius: ImageProperty = BloomRadius() { // TODO: Create ImageEffect protocol
        didSet {
            updateImage()
        }
    }

    // MARK: Filter

    var hasFilter: Bool {
        filter != nil
    }

    // MARK: Lifecycle

    init(lutsService: LutsServiceProtocol = LutsService()) {
        self.lutsService = lutsService
    }

    // MARK: Functions

    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation) {
        sourceCiImage = image
        sourceImageOrientation = orientation
        if let sourceUiImage = image.renderToUIImage(with: context, orientation: orientation) {
            sourceImage = Image(uiImage: sourceUiImage)
        }
        processedCiImage = image
        resetSettings()
    }

    func applyFilter(_ newFilter: Filter) {
        if filter?.id != newFilter.id {
            filter = newFilter
            updateImage()
        }
    }

    func removeFilterIfNeeded() {
        filter = nil
        updateImage()
    }

    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void) {
        if let processedCiImage, let uiImage = processedCiImage.renderToUIImage(with: context, orientation: sourceImageOrientation) {
            // Request permission to access the photo library
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    completion(.failure(.permissionToAccessPhotoLibraryDenied))
                    return
                }

                // Save the image
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                } completionHandler: { success, error in
                    if success {
                        completion(.success(()))
                    } else {
                        if let error {
                            completion(.failure(.photoLibraryError(description: error.localizedDescription)))
                        } else {
                            completion(.failure(.unknown))
                        }
                    }
                }
            }
        } else {
            completion(.failure(.missingProcessedImage))
        }
    }

    func reset() {
        sourceImage = nil
        processedCiImage = nil
        sourceImageOrientation = nil
        sourceCiImage = nil
        processedCiImage = nil
        filter = nil
        textureService.clear()
        resetSettings()
        resetEffects()
    }

    func resetSettings() {
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
}

// MARK: Private methods

private extension PhotoEditorService { // TODO: Crash
    func renderImage() {
        do {
            if let uiImage = processedCiImage?.renderToUIImage(with: context, orientation: sourceImageOrientation) {
                finalImage = Image(uiImage: uiImage)
            } else {
                throw PhotoEditorError.failedToRenderImage
            }
        } catch {
            Crashlytics.crashlytics().record(error: error)
            errorMessage = error.localizedDescription
        }
    }

    func renderHistogram() {
        let filter = CIFilter.histogramDisplay()
        filter.inputImage = processedCiImage
        filter.lowLimit = 0
        filter.highLimit = 1

        if let output = filter.outputImage {
            histogram = output.renderToUIImage(with: context)
        }
    }

    func downscale(image: CIImage, scale: CGFloat) -> CIImage? {
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        return filter.outputImage
    }

    func updateImage() {
        guard let sourceCiImage else { return }

        processedCiImage = downscale(
            image: sourceCiImage,
            scale: 0.5
        ) // TODO: Если изображение слишком маленькое, то при даунскейле оно может стать слишком пиксельным. Возможно стоит попробовать проверять к примеру высоты и/или ширину изображения, если оно больше определенного значения - даунскейлить

        // Properties
        applyFilter(colorControlsFilter, property: brightness)
        applyFilter(colorControlsFilter, property: contrast)
        applyFilter(colorControlsFilter, property: saturation)
        applyFilter(exposureAdjustFilter, property: exposure)
        applyFilter(vibranceFilter, property: vibrance)
        updateHS()
        applyFilter(gammaAdjustFilter, property: gamma)
        updateTemperatureAndTint()
        applyFilter(noiseReductionFilter, property: noiseReduction)
        applyFilter(noiseReductionFilter, property: sharpness)
        // Effects
        updateVignette()
        updateBloom()
        if let filter {
            configureFilter(filter)
        }
        if textureService.hasTexture {
            let result = textureService.overlayTexture(to: processedCiImage)
            switch result {
            case let .success(texturedImage):
                processedCiImage = texturedImage
            case let .failure(error):
                Crashlytics.crashlytics().record(error: error)
                errorMessage = error.localizedDescription
            }
        }
        renderHistogram()
        renderImage()
    }

    func resetEffects() {
        vignetteRadius.setToDefault()
        vignetteIntensity.setToDefault()
    }
}

// MARK: Private image properties funtions

private extension PhotoEditorService {
    // MARK: Image properties

    private func applyFilter(_ filter: CIFilter, property: some ImageProperty) {
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

    // MARK: Effects

    func updateVignette() {
        guard vignetteRadius.isUpdated || vignetteIntensity.isUpdated else {
            return
        }
        vignetteFilter.inputImage = processedCiImage
        vignetteFilter.intensity = vignetteIntensity.current
        vignetteFilter.radius = vignetteRadius.current
        processedCiImage = vignetteFilter.outputImage
    }

    func updateBloom() {
        guard bloomRadius.isUpdated || bloomIntensity.isUpdated else {
            return
        }

        bloomFilter.inputImage = processedCiImage
        bloomFilter.intensity = bloomIntensity.current
        bloomFilter.radius = bloomRadius.current
        if let originalExtent = processedCiImage?.extent, let croppedOutput = bloomFilter.outputImage?.cropped(to: originalExtent) {
            processedCiImage = croppedOutput
        }
    }

    func configureFilter(_ filter: Filter) {
        do {
            let filter = try lutsService.createCIColorCube(for: filter)
            filter.inputImage = processedCiImage
            processedCiImage = filter.outputImage
        } catch {
            Crashlytics.crashlytics().record(error: error)
            errorMessage = error.localizedDescription
        }
    }
}
