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

    private(set) var histogram: UIImage?

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

    private var imageProcessingService: ImageProcessingServiceProtocol
    private let filterService: FilterServiceProtocol
    private let textureService: TextureServiceProtocol

    private var processedCiImage: CIImage?
    private var sourceImageOrientation: UIImage.Orientation?

    private let context = CIContext() // TODO: Настроить CIContext

    private let vignetteFilter = CIFilter.vignette()
    private let bloomFilter = CIFilter.bloom()

    // MARK: Lifecycle

    init(
        imageProcessingService: ImageProcessingServiceProtocol = ImageProcessingService(),
        filterService: FilterServiceProtocol = FilterService(),
        textureService: TextureServiceProtocol = TextureService()
    ) {
        self.imageProcessingService = imageProcessingService
        self.filterService = filterService
        self.textureService = textureService
    }

    // MARK: Functions

    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation) {
        sourceCiImage = image
        sourceImageOrientation = orientation
        if let sourceUiImage = image.renderToUIImage(with: context, orientation: orientation) {
            sourceImage = Image(uiImage: sourceUiImage)
        }
        processedCiImage = image
        imageProcessingService.reset()
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
        filterService.removeFilter()
        textureService.clear()
        imageProcessingService.reset()
        resetEffects()
    }
}

// MARK: PhotoEditorFilter - свойтва и методы связанные с фильтрами

extension PhotoEditorService: PhotoEditorFilter {
    var hasFilter: Bool {
        filterService.hasFilter
    }

    var currentFilter: Filter? {
        filterService.currentFilter
    }

    func applyFilter(_ newLut: Filter) {
        filterService.update(to: newLut) {
            updateImage()
        }
    }

    func removeFilter() {
        filterService.removeFilter()
        updateImage()
    }
}

// MARK: PhotoEditorTexture - свойства и методы связанные с текстурами

extension PhotoEditorService: PhotoEditorTexture {
    var texture: Texture? {
        textureService.texture
    }

    var textureBlendMode: BlendMode {
        get {
            textureService.blendMode
        }
        set {
            textureService.updateBlendMode(to: newValue)
        }
    }

    var hasTexture: Bool {
        textureService.hasTexture
    }

    func updateTextureBlendMode(to newBlendMode: BlendMode) {
        textureService.updateBlendMode(to: newBlendMode)
        updateImage()
    }

    func applyTexture(_ newTexture: Texture) {
        textureService.update(to: newTexture) {
            updateImage()
        }
    }

    func removeTexture() {
        textureService.clear()
        updateImage()
    }

    var textureAlpha: Float {
        get {
            textureService.alpha
        }
        set {
            textureService.updateAlpha(to: newValue)
            updateImage()
        }
    }
}

// MARK: PhotoEditorImageProperties - свойства и методы связанные с изменением настроек изображения

extension PhotoEditorService: PhotoEditorImageProperties {
    var hasModifiedProperties: Bool {
        imageProcessingService.hasModifiedProperties
    }

    var brightness: ImageProperty {
        get {
            imageProcessingService.brightness
        }
        set {
            imageProcessingService.brightness = newValue
            updateImage()
        }
    }

    var contrast: ImageProperty {
        get {
            imageProcessingService.contrast
        }
        set {
            imageProcessingService.contrast = newValue
            updateImage()
        }
    }

    var saturation: ImageProperty {
        get {
            imageProcessingService.saturation
        }
        set {
            imageProcessingService.saturation = newValue
            updateImage()
        }
    }

    var exposure: ImageProperty {
        get {
            imageProcessingService.exposure
        }
        set {
            imageProcessingService.exposure = newValue
            updateImage()
        }
    }

    var vibrance: ImageProperty {
        get {
            imageProcessingService.vibrance
        }
        set {
            imageProcessingService.vibrance = newValue
            updateImage()
        }
    }

    var highlights: ImageProperty {
        get {
            imageProcessingService.highlights
        }
        set {
            imageProcessingService.highlights = newValue
            updateImage()
        }
    }

    var shadows: ImageProperty {
        get {
            imageProcessingService.shadows
        }
        set {
            imageProcessingService.shadows = newValue
            updateImage()
        }
    }

    var temperature: ImageProperty {
        get {
            imageProcessingService.temperature
        }
        set {
            imageProcessingService.temperature = newValue
            updateImage()
        }
    }

    var tint: ImageProperty {
        get {
            imageProcessingService.tint
        }
        set {
            imageProcessingService.tint = newValue
            updateImage()
        }
    }

    var gamma: ImageProperty {
        get {
            imageProcessingService.gamma
        }
        set {
            imageProcessingService.gamma = newValue
            updateImage()
        }
    }

    var noiseReduction: ImageProperty {
        get {
            imageProcessingService.noiseReduction
        }
        set {
            imageProcessingService.noiseReduction = newValue
            updateImage()
        }
    }

    var sharpness: ImageProperty {
        get {
            imageProcessingService.sharpness
        }
        set {
            imageProcessingService.sharpness = newValue
            updateImage()
        }
    }

    func resetImageProperties() {
        imageProcessingService.reset()
        updateImage()
    }
}

// MARK: Private methods

private extension PhotoEditorService {
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

        // TODO: Если изображение слишком маленькое, то при даунскейле оно может стать слишком пиксельным. Возможно стоит попробовать проверять к примеру высоты и/или ширину изображения, если оно больше определенного значения - даунскейлить
        // TODO: При рендеринге используется это же изображение низкого качества, исправить
        processedCiImage = downscale(
            image: sourceCiImage,
            scale: 0.5
        )
        processedCiImage = imageProcessingService.updateProperties(to: processedCiImage)
        // Effects
        updateVignette()
        updateBloom()

        if filterService.hasFilter {
            let applyLutResult = filterService.applyFilter(to: processedCiImage)
            switch applyLutResult {
            case let .success(lutImage):
                processedCiImage = lutImage
            case let .failure(error):
                Crashlytics.crashlytics().record(error: error)
                errorMessage = error.localizedDescription
            }
        }

        if textureService.hasTexture {
            let overlayTextureResult = textureService.overlayTexture(to: processedCiImage)
            switch overlayTextureResult {
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

private extension PhotoEditorService {
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
}
