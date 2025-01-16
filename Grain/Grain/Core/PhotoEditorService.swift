import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

@Observable
final class PhotoEditorService {
    private let context = CIContext() // Doc: Creating a CIContext is expensive, so create one during your initial setup and reuse it throughout your app.

    var sourceImage: Image? {
        if let sourceCiImage, let uiImage = renderCIImageToUIImage(sourceCiImage) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    /// Source Image doesn't change
    private var sourceCiImage: CIImage? = nil
    /// Filtered image using only for applying filters
    private var filteredCiImage: CIImage? = nil
    /// Textured Image using only for texture applying
    private var texturedCiImage: CIImage? = nil
    /// Final image after all updates
    var finalImage: Image? = nil
    private var texture: Texture? = nil
    private var textureBlendMode: BlendMode? = nil
    var hasTexture: Bool {
        texture != nil
    }
    var textureIntensity: Double = 1.0 {
        didSet {
            updateImage()
        }
    }

    func updateSourceImage(_ image: CIImage) {
        self.sourceCiImage = image
        filteredCiImage = image
        texturedCiImage = nil
        finalImage = nil
        resetFilters()
    }

    // Info.plist - NSPhotoLibraryUsageDescription - We need access to your photo library to save images you create in the app.
    func saveImageToPhotoLibrary() {
        if let texturedCiImage, let uiImage = renderCIImageToUIImage(texturedCiImage) {
            // Request permission to access the photo library
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    print("Permission to access photo library denied.")
                    return
                }

                // Save the image
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                } completionHandler: { success, error in
                    if let error = error {
                        print("Failed to save image: \(error.localizedDescription)")
                    } else if success {
                        print("Image saved successfully!")
                    } else {
                        print("Unknown error occurred while saving the image.")
                    }
                }
            }
        } else if let filteredCiImage, let uiImage = renderCIImageToUIImage(filteredCiImage) {
            // Request permission to access the photo library
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    print("Permission to access photo library denied.")
                    return
                }

                // Save the image
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                } completionHandler: { success, error in
                    if let error = error { // TODO: Create completions for showing success/error alerts
                        print("Failed to save image: \(error.localizedDescription)")
                    } else if success {
                        print("Image saved successfully!")
                    } else {
                        print("Unknown error occurred while saving the image.")
                    }
                }
            }
        } else {
            print("Something wrong in saveToGallery()") // TODO: Handle errors
        }
    }

    func resetFilters() {
        brightness.setToDefault() // TODO: Каждый раз вызывает didSet у каждого параметра
        contrast.setToDefault()
        saturation.setToDefault()
        exposure.setToDefault()
        vibrance.setToDefault()
        highlights.setToDefault()
        shadows.setToDefault()
        renderFinalImage()
    }

    func applyTexture(_ texture: Texture) {
        self.texture = texture
        textureBlendMode = texture.prefferedBlendMode
        overlayTexture(texture)
    }

    func histogram(height: CGFloat = 100) -> UIImage? {
        let filter = CIFilter.histogramDisplay()
        if let texturedCiImage {
            filter.inputImage = texturedCiImage
        } else if let filteredCiImage {
            filter.inputImage = filteredCiImage
        }
        filter.lowLimit = 0
        filter.highLimit = 1
        if let output = filter.outputImage {
            return renderCIImageToUIImage(output)
        }
        return nil
    }


    var brightness: Filter = Brightness() {
        didSet {
            updateImage()
        }
    }
    var contrast: Filter = Contrast() {
        didSet {
            updateImage()
        }
    }
    var saturation: Filter = Saturation() {
        didSet {
            updateImage()
        }
    }
    var exposure: Filter = Exposure() {
        didSet {
            updateImage()
        }
    }

    var vibrance: Filter = Vibrance() {
        didSet {
            updateImage()
        }
    }

    var highlights: Filter = Highlights() {
        didSet {
            updateImage()
        }
    }

    var shadows: Filter = Shadows() {
        didSet {
            updateImage()
        }
    }

    var temperature: Filter = Temperature() {
        didSet {
            updateImage()
        }
    }

    var tint: Filter = Tint() {
        didSet {
            updateImage()
        }
    }

    var noiseReduction: Filter = NoiseReduction() {
        didSet {
            updateImage()
        }
    }

    var sharpness: Filter = Sharpness() {
        didSet {
            updateImage()
        }
    }

    private func updateImage() {
        filteredCiImage = sourceCiImage
        updateBCS()
        updateExposure()
        updateVibrance()
        updateHS()
        updateTemperatureAndTint()
        updateNoiseReduction()
        if let texture {
            overlayTexture(texture)
        }
        renderFinalImage()
    }

    private func renderFinalImage() {
        if let texturedCiImage, let uiImage = renderCIImageToUIImage(texturedCiImage) {
            finalImage = Image(uiImage: uiImage)
        } else if let filteredCiImage, let uiImage = renderCIImageToUIImage(filteredCiImage) {
            finalImage = Image(uiImage: uiImage)
        } else {
            print("Something wrong in renderFinalImage()") // TODO: Handle errors
        }
    }

    private func updateTextureIntensity(of texture: CIImage, to alpha: CGFloat) -> CIImage? {
        let alphaFilter = CIFilter.colorMatrix()
        alphaFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: alpha), forKey: "inputAVector")
        alphaFilter.inputImage = texture
        return alphaFilter.outputImage
    }

    private func configureTexture(_ texture: CIImage, size: CGSize) -> CIImage? { // TODO: Refactor
        if let resized = resizeImageToAspectFill(image: texture, targetSize: size) {
            return updateTextureIntensity(of: resized, to: textureIntensity)
        }
        return nil
    }

    private func overlayTexture(_ texture: Texture) {
        if let uiImage = UIImage(named: texture.filename), let cgImage = uiImage.cgImage, let filteredCiImage, let configuredTexture = configureTexture(CIImage(cgImage: cgImage), size: filteredCiImage.extent.size) {
                if let filter = textureBlendMode?.ciFilter {
                    filter.backgroundImage = filteredCiImage
                    filter.inputImage = configuredTexture
                    texturedCiImage = filter.outputImage
                }
                renderFinalImage()
        } else {
            print("Texture doesn't exist or has wrong name") // TODO: Handle error
        }
    }

    func changeTextureBlendMode(to blendMode: BlendMode) {
        if textureBlendMode != blendMode {
            textureBlendMode = blendMode
        }
        updateImage()
    }


    private func resizeImageToAspectFill(image: CIImage, targetSize: CGSize) -> CIImage? {
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
        let transform = CGAffineTransform(scaleX: newSize.width / image.extent.size.width,
                                          y: newSize.height / image.extent.size.height)

        // Apply the transform to the image to resize it
        let resizedImage = image.transformed(by: transform)

        // Crop the image to fit exactly within the target size
        let croppedImage = resizedImage.cropped(to: CGRect(origin: .zero, size: targetSize))

        return croppedImage
    }

    private func renderCIImageToUIImage(_ ciImage: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

// Private update functions
private extension PhotoEditorService {
    // Brightness, Contrast & Saturation
    private func updateBCS() {
        let filter = CIFilter.colorControls()
        filter.inputImage = filteredCiImage
        filter.brightness = brightness.current
        filter.contrast = contrast.current
        filter.saturation = saturation.current
        filteredCiImage = filter.outputImage
    }

    private func updateExposure() {
        let filter = CIFilter.exposureAdjust()
        filter.inputImage = filteredCiImage
        filter.ev = exposure.current
        filteredCiImage = filter.outputImage
    }

    private func updateVibrance() {
        let filter = CIFilter.vibrance()
        filter.inputImage = filteredCiImage
        filter.amount = vibrance.current
        filteredCiImage = filter.outputImage
    }

    // Highlights & Shadows
    private func updateHS() {
        let filter = CIFilter.highlightShadowAdjust()
        filter.inputImage = filteredCiImage
        filter.highlightAmount = highlights.current
        filter.shadowAmount = shadows.current
        filteredCiImage = filter.outputImage
    }

    private func updateVignette() {
        let filter = CIFilter.vignette()
        filter.inputImage = filteredCiImage
        filter.intensity = 0
        filter.radius = 0
        filteredCiImage = filter.outputImage
    }

    private func updateTemperatureAndTint() {
        let filter = CIFilter.temperatureAndTint()
        filter.inputImage = filteredCiImage
        filter.neutral = CIVector(x: CGFloat(temperature.defaultValue), y: 0)
        filter.targetNeutral = CIVector(x: CGFloat(temperature.current), y: CGFloat(tint.current))
        filteredCiImage = filter.outputImage
    }

    private func updateNoiseReduction() {
        let filter = CIFilter.noiseReduction()
        filter.inputImage = filteredCiImage
        filter.noiseLevel = noiseReduction.current
        filter.sharpness = sharpness.current
        filteredCiImage = filter.outputImage
    }
}
