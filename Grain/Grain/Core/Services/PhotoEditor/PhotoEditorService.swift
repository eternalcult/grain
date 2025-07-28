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
        if let finalImage = renderImageForExport() {
            // Request permission to access the photo library
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    completion(.failure(.permissionToAccessPhotoLibraryDenied))
                    return
                }

                // Save the image
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: finalImage)
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

    func clearAll() {
        removeFilter()
        resetImageProperties()
        resetEffects()
        removeTexture()
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
            updateProcessedImage()
        }
    }

    func removeFilter() {
        logger.info(#function)
        filterService.clear()
        updateProcessedImage()
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
            updateProcessedImage()
        }
    }

    var hasTexture: Bool {
        textureService.hasTexture
    }

    func applyTexture(_ newTexture: Texture) { // TODO: Handle errors
        logger.info(#function)
        textureService.prepare(to: newTexture) {
            updateProcessedImage()
        }
    }

    func removeTexture() {
        logger.info(#function)
        textureService.clear()
        updateProcessedImage()
    }

    var textureAlpha: Float {
        get {
            textureService.alpha
        }
        set {
            textureService.updateAlpha(to: newValue)
            updateProcessedImage()
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
            updateProcessedImage()
        }
    }

    var contrast: ImagePropertyProtocol {
        get {
            imageProcessingService.contrast
        }
        set {
            imageProcessingService.contrast = newValue
            updateProcessedImage()
        }
    }

    var saturation: ImagePropertyProtocol {
        get {
            imageProcessingService.saturation
        }
        set {
            imageProcessingService.saturation = newValue
            updateProcessedImage()
        }
    }

    var exposure: ImagePropertyProtocol {
        get {
            imageProcessingService.exposure
        }
        set {
            imageProcessingService.exposure = newValue
            updateProcessedImage()
        }
    }

    var vibrance: ImagePropertyProtocol {
        get {
            imageProcessingService.vibrance
        }
        set {
            imageProcessingService.vibrance = newValue
            updateProcessedImage()
        }
    }

    var highlights: ImagePropertyProtocol {
        get {
            imageProcessingService.highlights
        }
        set {
            imageProcessingService.highlights = newValue
            updateProcessedImage()
        }
    }

    var shadows: ImagePropertyProtocol {
        get {
            imageProcessingService.shadows
        }
        set {
            imageProcessingService.shadows = newValue
            updateProcessedImage()
        }
    }

    var temperature: ImagePropertyProtocol {
        get {
            imageProcessingService.temperature
        }
        set {
            imageProcessingService.temperature = newValue
            updateProcessedImage()
        }
    }

    var tint: ImagePropertyProtocol {
        get {
            imageProcessingService.tint
        }
        set {
            imageProcessingService.tint = newValue
            updateProcessedImage()
        }
    }

    var gamma: ImagePropertyProtocol {
        get {
            imageProcessingService.gamma
        }
        set {
            imageProcessingService.gamma = newValue
            updateProcessedImage()
        }
    }

    var noiseReduction: ImagePropertyProtocol {
        get {
            imageProcessingService.noiseReduction
        }
        set {
            imageProcessingService.noiseReduction = newValue
            updateProcessedImage()
        }
    }

    var sharpness: ImagePropertyProtocol {
        get {
            imageProcessingService.sharpness
        }
        set {
            imageProcessingService.sharpness = newValue
            updateProcessedImage()
        }
    }

    func resetImageProperties() {
        logger.info(#function)
        imageProcessingService.reset()
        updateProcessedImage()
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
            updateProcessedImage()
        }
    }

    var bloom: ImageEffectProtocol {
        get {
            imageProcessingService.bloom
        } set {
            imageProcessingService.bloom = newValue
            updateProcessedImage()
        }
    }

    func resetEffects() {
        logger.info(#function)
        imageProcessingService.resetEffects()
        if sourceImage != nil {
            updateProcessedImage()
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

    /// Рендерит изображение с полным разрешением для экспорта
    func renderImageForExport() -> UIImage? {
        logger.info(#function)
        do {
            guard let sourceCiImage else { throw PhotoEditorError.sourceImageIsMissingWhileTryingToUpdateImage }
            var finalCiImage = sourceCiImage
            finalCiImage = try imageProcessingService.updatePropertiesAndEffects(to: finalCiImage)
            finalCiImage = try filterService.applyFilterIfNeeded(to: finalCiImage)
            finalCiImage = try textureService.overlayTextureIfNeeded(to: finalCiImage)
            return finalCiImage.renderToUIImage(with: context, orientation: sourceImageOrientation)
        } catch {
            Crashlytics.crashlytics().record(error: error)
            errorMessage = error.localizedDescription
            logger.error("\(#function) \(error.localizedDescription)")
        }
        return nil
    }

    /// Обновляет обработанное изображение, если изображение больше чем 1024px по одной из сторон, применяется даунскейл для быстрой отрисовки превью
    func updateProcessedImage() {
        logger.info(#function)
        do {
            guard let sourceCiImage else { throw PhotoEditorError.sourceImageIsMissingWhileTryingToUpdateImage }
            guard var processedCiImage else { throw PhotoEditorError.processedImageIsMissingWhileTryingToUpdateImage }
            

            let imageSize = sourceCiImage.extent.size
            let shouldDownscale = max(imageSize.width, imageSize.height) > 1024
            
            if shouldDownscale { // Определяем нужно ли масштабировать изображение
                processedCiImage = try downscale(
                    image: sourceCiImage,
                    scale: 0.5
                )
            } else { // Используем оригинальное изображение без масштабирования
                processedCiImage = sourceCiImage
            }
            
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
