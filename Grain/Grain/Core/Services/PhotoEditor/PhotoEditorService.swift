import CoreImage
import CoreImage.CIFilterBuiltins
import Factory
import FirebaseCrashlytics
import os
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

    private let logger = Logger.photoEditor

    // MARK: DI

    @ObservationIgnored @Injected(\.imageProcessingService) private var imageProcessingService
    @ObservationIgnored @Injected(\.filterService) private var filterService
    @ObservationIgnored @Injected(\.textureService) private var textureService

    private var processedCiImage: CIImage?
    private var sourceImageOrientation: UIImage.Orientation?

    private let context = CIContext() // TODO: Настроить CIContext

    // MARK: Functions

    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation) {
        logger.info(#function)
        sourceCiImage = image
        sourceImageOrientation = orientation
        if let sourceUiImage = image.renderToUIImage(with: context, orientation: orientation) { // TODO: Handle errors
            sourceImage = Image(uiImage: sourceUiImage)
        }
        processedCiImage = image
        imageProcessingService.reset()
    }

    // TODO: Result completion
    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void) {
        logger.info(#function)
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
        logger.info(#function)
        sourceImage = nil
        processedCiImage = nil
        sourceImageOrientation = nil
        sourceCiImage = nil
        processedCiImage = nil
        finalImage = nil
        histogram = nil
        filterService.clear()
        textureService.clear()
        imageProcessingService.reset()
        resetEffects()
    }
}

// MARK: PhotoEditorFilter - свойтва и методы связанные с фильтрами

extension PhotoEditorService {
    var hasFilter: Bool {
        filterService.hasFilter
    }

    var currentFilter: Filter? {
        filterService.currentFilter
    }

    func applyFilter(_ newLut: Filter) {
        logger.info(#function)
        filterService.prepare(to: newLut) {
            updateImage()
        }
    }

    func removeFilter() {
        logger.info(#function)
        filterService.clear()
        updateImage()
    }
}

// MARK: PhotoEditorTexture - свойства и методы связанные с текстурами

extension PhotoEditorService {
    var texture: Texture? {
        textureService.texture
    }

    var textureBlendMode: BlendMode {
        get {
            textureService.blendMode
        }
        set {
            textureService.updateBlendMode(to: newValue)
            updateImage()
        }
    }

    var hasTexture: Bool {
        textureService.hasTexture
    }

    func applyTexture(_ newTexture: Texture) { // TODO: Handle errors
        logger.info(#function)
        textureService.prepare(to: newTexture) {
            updateImage()
        }
    }

    func removeTexture() {
        logger.info(#function)
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

extension PhotoEditorService {
    var hasModifiedProperties: Bool {
        imageProcessingService.hasModifiedProperties
    }

    var brightness: ImagePropertyProtocol {
        get {
            imageProcessingService.brightness
        }
        set {
            imageProcessingService.brightness = newValue
            updateImage()
        }
    }

    var contrast: ImagePropertyProtocol {
        get {
            imageProcessingService.contrast
        }
        set {
            imageProcessingService.contrast = newValue
            updateImage()
        }
    }

    var saturation: ImagePropertyProtocol {
        get {
            imageProcessingService.saturation
        }
        set {
            imageProcessingService.saturation = newValue
            updateImage()
        }
    }

    var exposure: ImagePropertyProtocol {
        get {
            imageProcessingService.exposure
        }
        set {
            imageProcessingService.exposure = newValue
            updateImage()
        }
    }

    var vibrance: ImagePropertyProtocol {
        get {
            imageProcessingService.vibrance
        }
        set {
            imageProcessingService.vibrance = newValue
            updateImage()
        }
    }

    var highlights: ImagePropertyProtocol {
        get {
            imageProcessingService.highlights
        }
        set {
            imageProcessingService.highlights = newValue
            updateImage()
        }
    }

    var shadows: ImagePropertyProtocol {
        get {
            imageProcessingService.shadows
        }
        set {
            imageProcessingService.shadows = newValue
            updateImage()
        }
    }

    var temperature: ImagePropertyProtocol {
        get {
            imageProcessingService.temperature
        }
        set {
            imageProcessingService.temperature = newValue
            updateImage()
        }
    }

    var tint: ImagePropertyProtocol {
        get {
            imageProcessingService.tint
        }
        set {
            imageProcessingService.tint = newValue
            updateImage()
        }
    }

    var gamma: ImagePropertyProtocol {
        get {
            imageProcessingService.gamma
        }
        set {
            imageProcessingService.gamma = newValue
            updateImage()
        }
    }

    var noiseReduction: ImagePropertyProtocol {
        get {
            imageProcessingService.noiseReduction
        }
        set {
            imageProcessingService.noiseReduction = newValue
            updateImage()
        }
    }

    var sharpness: ImagePropertyProtocol {
        get {
            imageProcessingService.sharpness
        }
        set {
            imageProcessingService.sharpness = newValue
            updateImage()
        }
    }

    func resetImageProperties() {
        logger.info(#function)
        imageProcessingService.reset()
        updateImage()
    }
}

// MARK: PhotoEditorEffects

extension PhotoEditorService: PhotoEditorEffects {
    var hasModifiedEffects: Bool {
        imageProcessingService.hasModifiedEffects
    }

    var vignette: ImageEffectProtocol {
        get {
            imageProcessingService.vignette
        } set {
            imageProcessingService.vignette = newValue
            updateImage()
        }
    }

    var bloom: ImageEffectProtocol {
        get {
            imageProcessingService.bloom
        } set {
            imageProcessingService.bloom = newValue
            updateImage()
        }
    }

    func resetEffects() {
        logger.info(#function)
        imageProcessingService.resetEffects()
        if sourceImage != nil {
            updateImage()
        }
    }
}

// MARK: Private methods

private extension PhotoEditorService {
    func renderImage() throws {
        logger.info(#function)
        do {
            if let uiImage = processedCiImage?.renderToUIImage(with: context, orientation: sourceImageOrientation) {
                finalImage = Image(uiImage: uiImage)
            } else {
                throw PhotoEditorError.failedToRenderImage
            }
        } catch {
            throw error
        }
    }

    func renderHistogram() throws {
        logger.info(#function)
        let filter = CIFilter.histogramDisplay()
        filter.inputImage = processedCiImage
        filter.lowLimit = 0
        filter.highLimit = 1

        if let output = filter.outputImage {
            histogram = output.renderToUIImage(with: context)
        } else {
            throw PhotoEditorError.histogramRenderIssue
        }
    }

    func downscale(image: CIImage, scale: CGFloat) throws -> CIImage {
        logger.info(#function)
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        if let outputImage = filter.outputImage {
            return outputImage
        } else {
            throw PhotoEditorError.downscalingIssue
        }
    }

    // TODO: Если изображение слишком маленькое, то при даунскейле оно может стать слишком пиксельным. Возможно стоит попробовать проверять к примеру высоты и/или ширину изображения, если оно больше определенного значения - даунскейлить. При рендеринге используется это же изображение низкого качества.
    func updateImage() {
        logger.info(#function)
        do {
            guard let sourceCiImage else { throw PhotoEditorError.sourceImageIsMissingWhileTryingToUpdateImage }
            guard var processedCiImage else { throw PhotoEditorError.processedImageIsMissingWhileTryingToUpdateImage }
            processedCiImage = try downscale(
                image: sourceCiImage,
                scale: 0.8
            )
            processedCiImage = try imageProcessingService.updatePropertiesAndEffects(to: processedCiImage)
            processedCiImage = try filterService.applyFilterIfNeeded(to: processedCiImage)
            processedCiImage = try textureService.overlayTextureIfNeeded(to: processedCiImage)
            self.processedCiImage = processedCiImage
            try renderHistogram()
            try renderImage()
        } catch {
            Crashlytics.crashlytics().record(error: error)
            errorMessage = error.localizedDescription
            logger.error("\(#function) \(error.localizedDescription)")
        }
    }
}
