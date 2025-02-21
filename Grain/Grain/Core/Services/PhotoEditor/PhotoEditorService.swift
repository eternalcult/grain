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
    // TODO: DI

    private(set) var sourceImage: Image?
    /// Source Image doesn't change
    private(set) var sourceCiImage: CIImage?
    /// Final Image after all updates
    private(set) var finalImage: Image?
    /// Final CIImage after all updates
    private(set) var finalCiImage: CIImage?

    // MARK: Texture

    private(set) var texture: Texture?
    private(set) var textureBlendMode: BlendMode = .normal

    // MARK: Filter

    private(set) var filter: Filter?

    private(set) var histogram: UIImage?

    private let lutsService: LutsServiceProtocol
    /// Is used only for private applying chain of filters and don't update UI after each filter update
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


    private let context = CIContext() // TODO: Настроить CIContext

    // MARK: Computed Properties

    var propertiesModified: Bool {
        brightness.isUpdated || contrast.isUpdated || saturation.isUpdated || exposure.isUpdated || vibrance.isUpdated || highlights
            .isUpdated || shadows.isUpdated || temperature.isUpdated || tint.isUpdated || gamma.isUpdated || noiseReduction
            .isUpdated || sharpness.isUpdated
    }

    var brightness: ImageProperty = Brightness() {
        didSet {
            updateTask()
        }
    }

    var contrast: ImageProperty = Contrast() {
        didSet {
            updateTask()
        }
    }

    var saturation: ImageProperty = Saturation() {
        didSet {
            updateTask()
        }
    }

    var exposure: ImageProperty = Exposure() {
        didSet {
            updateTask()
        }
    }

    var vibrance: ImageProperty = Vibrance() {
        didSet {
            updateTask()
        }
    }

    var highlights: ImageProperty = Highlights() {
        didSet {
            updateTask()
        }
    }

    var shadows: ImageProperty = Shadows() {
        didSet {
            updateTask()
        }
    }

    var temperature: ImageProperty = Temperature() {
        didSet {
            updateTask()
        }
    }

    var tint: ImageProperty = Tint() {
        didSet {
            updateTask()
        }
    }

    var gamma: ImageProperty = Gamma() {
        didSet {
            updateTask()
        }
    }

    var noiseReduction: ImageProperty = NoiseReduction() {
        didSet {
            updateTask()
        }
    }

    var sharpness: ImageProperty = Sharpness() {
        didSet {
            updateTask()
        }
    }

    // MARK: Effects

    var vignetteIntensity: ImageProperty = VignetteIntensity() {
        didSet {
            updateTask()
        }
    }

    var vignetteRadius: ImageProperty = VignetteRadius() {
        didSet {
            updateTask()
        }
    }

    // MARK: Texture

    var hasTexture: Bool {
        texture != nil
    }

    var textureIntensity: Float = 0.5 {
        didSet {
            updateTask()
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
        if let sourceUiImage = renderCIImageToUIImage(image) {
            sourceImage = Image(uiImage: sourceUiImage)
        }
        processedCiImage = image
        finalImage = nil
        resetSettings()
    }

    func applyTexture(_ newTexture: Texture) {
        if texture?.id != newTexture.id {
            texture = newTexture
            updateTask()
        }
    }

    func applyTextureBlendMode(to newBlendMode: BlendMode) {
        if textureBlendMode != newBlendMode {
            textureBlendMode = newBlendMode
        }
        updateTask()
    }

    func removeTextureIfNeeded() {
        texture = nil
        textureIntensity = 0.5
        textureBlendMode = .normal
        updateTask()
    }

    func applyFilter(_ newFilter: Filter) {
        if filter?.id != newFilter.id {
            filter = newFilter
            updateTask()
        }
    }

    func removeFilterIfNeeded() {
        filter = nil
        updateTask()
    }

    // Info.plist - NSPhotoLibraryUsageDescription - We need access to your photo library to save images you create in the app.
    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void) {
        if let processedCiImage, let uiImage = renderCIImageToUIImage(processedCiImage) {
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
        finalImage = nil
        filter = nil
        texture = nil
        textureBlendMode = .normal
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
    func renderHistogram() {
        let filter = CIFilter.histogramDisplay()
        filter.inputImage = processedCiImage
        filter.lowLimit = 0
        filter.highLimit = 1

        if let output = filter.outputImage {
            histogram = renderCIImageToUIImage(output)
        }
    }

    func downscale(image: CIImage, scale: CGFloat)  -> CIImage? {
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        return filter.outputImage
    }

    func updateTask() {
        guard let sourceCiImage else { return }

        processedCiImage = downscale(image: sourceCiImage, scale: 0.5) // TODO: Если изображение слишком маленькое, то при даунскейле оно может стать слишком пиксельным. Возможно стоит попробовать проверять к примеру высоты и/или ширину изображения, если оно больше определенного значения - даунскейлить

        // Properties
        updateBCS()
        updateExposure()
        updateVibrance()
        updateHS()
        updateTemperatureAndTint()
        updateGamma()
        updateNoiseReduction()
        // Effects
        updateVignette()
        if let filter {
            configureFilter(filter)
        }
        if let texture {
            overlayTexture(texture)
        }
        renderHistogram()
        renderImage()

    }

    func resetEffects() {
        vignetteRadius.setToDefault()
        vignetteIntensity.setToDefault()
    }

    func renderImage() {
        do {
            if let processedCiImage, let uiImage = renderCIImageToUIImage(processedCiImage) {
                finalCiImage = processedCiImage
                finalImage = Image(uiImage: uiImage)
            } else {
                throw PhotoEditorError.failedToRenderImage
            }
        } catch {
                Crashlytics.crashlytics().record(error: error)
                errorMessage = error.localizedDescription
        }
    }

    func updateTextureIntensity(of texture: CIImage, to alpha: CGFloat) -> CIImage? {
        let alphaFilter = CIFilter.colorMatrix()
        alphaFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: alpha), forKey: "inputAVector")
        alphaFilter.inputImage = texture
        return alphaFilter.outputImage
    }

    func configureTexture(_ texture: CIImage, size: CGSize) -> CIImage? { // TODO: Refactor
        if let resized = resizeImageToAspectFill(image: texture, targetSize: size) {
            return updateTextureIntensity(of: resized, to: CGFloat(textureIntensity))
        }
        return nil
    }

    func resizeImageToAspectFill(image: CIImage, targetSize: CGSize) -> CIImage? {
        // Calculate the aspect ratio of the original image
        let aspectRatio = image.extent.size.width / image.extent.size.height
        var newSize = targetSize

        // Scale the image to ensure it fills the target size (aspect fill)
        if targetSize.width / targetSize.height > aspectRatio {
            newSize.height = targetSize.width / aspectRatio
        } else {
            newSize.width = targetSize.height * aspectRatio
        }

        // Create a transform to scale the image to the new size
        let transform = CGAffineTransform(
            scaleX: newSize.width / image.extent.size.width,
            y: newSize.height / image.extent.size.height
        )

        // Apply the transform to the image to resize it
        let resizedImage = image.transformed(by: transform)

        // Crop the image to fit exactly within the target size
        return resizedImage.cropped(to: CGRect(origin: .zero, size: targetSize))
    }

    func renderCIImageToUIImage(_ ciImage: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: 1, orientation: sourceImageOrientation ?? .up)
    }
}

// MARK: Private image properties funtions

private extension PhotoEditorService {
    // MARK: Image properties

    // Brightness, Contrast & Saturation
    func updateBCS() {
        guard brightness.isUpdated || contrast.isUpdated || saturation.isUpdated else {
            return
        }
        colorControlsFilter.inputImage = processedCiImage
        colorControlsFilter.brightness = brightness.current
        colorControlsFilter.contrast = contrast.current
        colorControlsFilter.saturation = saturation.current
        processedCiImage = colorControlsFilter.outputImage
    }

    func updateExposure() {
        guard exposure.isUpdated else {
            return
        }
        exposureAdjustFilter.inputImage = processedCiImage
        exposureAdjustFilter.ev = exposure.current
        processedCiImage = exposureAdjustFilter.outputImage
    }

    func updateVibrance() {
        guard exposure.isUpdated else {
            return
        }
        vibranceFilter.inputImage = processedCiImage
        vibranceFilter.amount = vibrance.current
        processedCiImage = vibranceFilter.outputImage
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

    func updateGamma() {
        guard gamma.isUpdated else {
            return
        }
        gammaAdjustFilter.inputImage = processedCiImage
        gammaAdjustFilter.power = gamma.current
        processedCiImage = gammaAdjustFilter.outputImage
    }

    func updateNoiseReduction() {
        guard noiseReduction.isUpdated || sharpness.isUpdated else {
            return
        }
        noiseReductionFilter.inputImage = processedCiImage
        noiseReductionFilter.noiseLevel = noiseReduction.current
        noiseReductionFilter.sharpness = sharpness.current
        processedCiImage = noiseReductionFilter.outputImage
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

    // MARK: Textures & Filters

    func overlayTexture(_ texture: Texture) {
        do {
            guard let uiImage = UIImage(named: texture.filename),
                  let cgImage = uiImage.cgImage,
                  let processedCiImage,
                  let configuredTexture = configureTexture(CIImage(cgImage: cgImage), size: processedCiImage.extent.size)
            else {
                throw PhotoEditorError.textureDoesntExistOrHasWrongName
            }

            let blendMode = textureBlendMode.ciFilter
            blendMode.backgroundImage = processedCiImage
            blendMode.inputImage = configuredTexture
            self.processedCiImage = blendMode.outputImage
        } catch {
            Crashlytics.crashlytics().record(error: error)
            errorMessage = error.localizedDescription
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
