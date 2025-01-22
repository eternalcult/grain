import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

@Observable
final class PhotoEditorService {

    //    private let context = CIContext(options:  [ // TODO: Decide should I use it or not?
    //        .priorityRequestLow: true, // Lower priority if running multiple tasks
    //        .useSoftwareRenderer: false, // Forces the use of the GPU renderer.
    //        .highQualityDownsample: false,
    //        .allowLowPower: true
    //    ] )

    private let context = CIContext() // Doc: Creating a CIContext is expensive, so create one during your initial setup and reuse it throughout your app.
    let lutsManager = LutsManager()

    // TODO: DI

    private(set) var sourceImage: Image? = nil
    private var sourceImageOrientation: UIImage.Orientation? = nil
    /// Source Image doesn't change
    private(set) var sourceCiImage: CIImage? = nil
    private(set) var filteredCiImage: CIImage? = nil
    /// Final image after all updates
    var finalImage: Image? = nil

    // MARK: Texture
    private(set) var texture: Texture? = nil
    private(set) var textureBlendMode: BlendMode = .normal
    var hasTexture: Bool {
        texture != nil
    }
    var textureIntensity: Double = 0.5 {
        didSet {
            updateImage()
        }
    }
    // MARK: Filter
    private(set) var filter: Filter? = nil
    var hasFilter: Bool {
        filter != nil
    }

    func reset() {
        sourceImage = nil
        sourceImageOrientation = nil
        sourceCiImage = nil
        filteredCiImage = nil
        finalImage = nil
        filter = nil
        texture = nil
        textureBlendMode = .normal
        resetFilters()
    }

    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation) {
        self.sourceCiImage = image
        self.sourceImageOrientation = orientation
        if let sourceUiImage = renderCIImageToUIImage(image) {
            self.sourceImage = Image(uiImage: sourceUiImage)
        }
        filteredCiImage = image
        finalImage = nil
        resetFilters()
    }

    func applyTexture(_ newTexture: Texture) {
        if texture?.id != newTexture.id {
            texture = newTexture
            updateImage()
        }
    }

    private func overlayTexture(_ texture: Texture) {
        if let uiImage = UIImage(named: texture.filename),
           let cgImage = uiImage.cgImage,
           let filteredCiImage,
           let configuredTexture = configureTexture(CIImage(cgImage: cgImage), size: filteredCiImage.extent.size) {
            let blendMode = textureBlendMode.ciFilter
            blendMode.backgroundImage = filteredCiImage
            blendMode.inputImage = configuredTexture
            self.filteredCiImage = blendMode.outputImage
        } else {
            print("Texture doesn't exist or has wrong name") // TODO: Handle error
        }
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
    func removeTextureIfNeeded() {
        texture = nil
        textureIntensity = 0.5
        textureBlendMode = .normal
        updateImage()
    }

    private func configureFilter(_ filter: Filter) {
        if let filter = lutsManager.createCIColorCube(for: filter) {
            filter.inputImage = filteredCiImage
            filteredCiImage = filter.outputImage
        } else {
            print("Issue with applying filter") // TODO: Handle errors
        }
    }


    func updateTextureBlendMode(to newBlendMode: BlendMode) {
        if textureBlendMode != newBlendMode {
            textureBlendMode = newBlendMode
        }
        updateImage()
    }

    // Info.plist - NSPhotoLibraryUsageDescription - We need access to your photo library to save images you create in the app.
    func saveImageToPhotoLibrary() {
        if let filteredCiImage, let uiImage = renderCIImageToUIImage(filteredCiImage) {
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
        brightness.setToDefault()
        contrast.setToDefault()
        saturation.setToDefault()
        exposure.setToDefault()
        vibrance.setToDefault()
        highlights.setToDefault()
        shadows.setToDefault()
        noiseReduction.setToDefault()
        sharpness.setToDefault()
        gamma.setToDefault()
        renderFinalImage()
    }

    func histogram(height: CGFloat = 100) -> UIImage? {
        let filter = CIFilter.histogramDisplay()
        filter.inputImage = filteredCiImage
        filter.lowLimit = 0
        filter.highLimit = 1
        if let output = filter.outputImage {
            return renderCIImageToUIImage(output)
        }
        return nil
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

    private func updateImage() {
        guard let sourceCiImage else { return }
        filteredCiImage = sourceCiImage
        updateBCS()
        updateExposure()
        updateVibrance()
        updateHS()
        updateTemperatureAndTint()
        updateGamma()
        updateNoiseReduction()
        if let filter {
            configureFilter(filter)
        }
        if let texture {
            overlayTexture(texture)
        }
        renderFinalImage()
    }

    private func renderFinalImage() {
        if let filteredCiImage, let uiImage = renderCIImageToUIImage(filteredCiImage) {
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
        return UIImage(cgImage: cgImage, scale: 1, orientation: sourceImageOrientation ?? .up)
    }


}

// Private update functions
private extension PhotoEditorService {
    // Brightness, Contrast & Saturation
    func updateBCS() {
        let filter = CIFilter.colorControls()
        filter.inputImage = filteredCiImage
        filter.brightness = brightness.current
        filter.contrast = contrast.current
        filter.saturation = saturation.current
        filteredCiImage = filter.outputImage
    }

    func updateExposure() {
        let filter = CIFilter.exposureAdjust()
        filter.inputImage = filteredCiImage
        filter.ev = exposure.current
        filteredCiImage = filter.outputImage
    }

    func updateVibrance() {
        let filter = CIFilter.vibrance()
        filter.inputImage = filteredCiImage
        filter.amount = vibrance.current
        filteredCiImage = filter.outputImage
    }

    // Highlights & Shadows
    func updateHS() {
        let filter = CIFilter.highlightShadowAdjust()
        filter.inputImage = filteredCiImage
        filter.highlightAmount = highlights.current
        filter.shadowAmount = shadows.current
        filteredCiImage = filter.outputImage
    }

    func updateVignette() {
        let filter = CIFilter.vignette()
        filter.inputImage = filteredCiImage
        filter.intensity = 0
        filter.radius = 0
        filteredCiImage = filter.outputImage
    }

    func updateTemperatureAndTint() {
        let filter = CIFilter.temperatureAndTint()
        filter.inputImage = filteredCiImage
        filter.neutral = CIVector(x: CGFloat(temperature.defaultValue), y: 0)
        filter.targetNeutral = CIVector(x: CGFloat(temperature.current), y: CGFloat(tint.current))
        filteredCiImage = filter.outputImage
    }

    func updateGamma() {
        let filter = CIFilter.gammaAdjust()
        filter.inputImage = filteredCiImage
        filter.power = gamma.current
        filteredCiImage = filter.outputImage
    }

    func updateNoiseReduction() {
        let filter = CIFilter.noiseReduction()
        filter.inputImage = filteredCiImage
        filter.noiseLevel = noiseReduction.current
        filter.sharpness = sharpness.current
        filteredCiImage = filter.outputImage
    }
}
