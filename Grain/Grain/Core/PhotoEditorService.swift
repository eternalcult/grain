import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

@Observable
final class PhotoEditorService {
    private let context = CIContext() // Doc: Creating a CIContext is expensive, so create one during your initial setup and reuse it throughout your app.

    /// Source Image doesn't change
    private var sourceImage: CIImage? = nil
    /// Filtered image using only for applying filters
    private var filteredImage: CIImage? = nil
    /// Textured Image using only for texture applying
    private var texturedImage: CIImage? = nil
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
        self.sourceImage = image
        filteredImage = image
        texturedImage = nil
        finalImage = nil
        resetFilters()
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

    private func updateImage() {
        filteredImage = sourceImage
        updateBCS()
        updateExposure()
        updateVibrance()
        updateHS()
        if let texture {
            overlayTexture(texture)
        }
        renderFinalImage()
    }

    private func renderFinalImage() {
        if let texturedImage {
            if let cgImage = context.createCGImage(texturedImage, from: texturedImage.extent) {
                print("Generate image after all updates")
                let uiImage = UIImage(cgImage: cgImage)
                finalImage = Image(uiImage: uiImage)
            }
        } else if let filteredImage {
            if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) {
                print("Generate image after all updates")
                let uiImage = UIImage(cgImage: cgImage)
                finalImage = Image(uiImage: uiImage)
            }
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
        if let uiImage = UIImage(named: texture.filename), let cgImage = uiImage.cgImage, let filteredImage, let configuredTexture = configureTexture(CIImage(cgImage: cgImage), size: filteredImage.extent.size) {
                if let filter = textureBlendMode?.ciFilter {
                    filter.backgroundImage = filteredImage
                    filter.inputImage = configuredTexture
                    texturedImage = filter.outputImage
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
}

// Private update functions
private extension PhotoEditorService {
    // Brightness, Contrast & Saturation
    private func updateBCS() {
        let filter = CIFilter.colorControls()
        filter.inputImage = filteredImage
        filter.brightness = brightness.current
        filter.contrast = contrast.current
        filter.saturation = saturation.current
        filteredImage = filter.outputImage
    }

    private func updateExposure() {
        let filter = CIFilter.exposureAdjust()
        filter.inputImage = filteredImage
        filter.ev = exposure.current
        filteredImage = filter.outputImage
    }

    private func updateVibrance() {
        let filter = CIFilter.vibrance()
        filter.inputImage = filteredImage
        filter.amount = vibrance.current
        filteredImage = filter.outputImage
    }

    // Highlights & Shadows
    private func updateHS() {
        let filter = CIFilter.highlightShadowAdjust()
        filter.inputImage = filteredImage
        filter.highlightAmount = highlights.current
        filter.shadowAmount = shadows.current
        filteredImage = filter.outputImage
    }

    private func updateVignette() {
        let filter = CIFilter.vignette()
        filter.inputImage = filteredImage
        filter.intensity = 0
        filter.radius = 0
        filteredImage = filter.outputImage
    }
}
