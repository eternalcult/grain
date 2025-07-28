import CoreImage
import UIKit

// MARK: - TextureService

@Observable
final class TextureService: TextureServiceProtocol {
    // MARK: Properties

    private(set) var texture: Texture?
    private(set) var blendMode: BlendMode = .normal
    private(set) var alpha: Float = 0.5

    // MARK: Computed Properties

    var hasTexture: Bool {
        texture != nil
    }

    // MARK: Functions

    func prepare(to newTexture: Texture, completion: Completion) { // TODO: Handle errors, check if texture exist, remove completion?
        if texture?.id != newTexture.id {
            texture = newTexture
            completion()
        }
    }

    func updateAlpha(to newValue: Float) {
        alpha = newValue
    }

    func updateBlendMode(to newBlendMode: BlendMode) {
        if blendMode != newBlendMode {
            blendMode = newBlendMode
        }
    }

    func overlayTextureIfNeeded(to processedCiImage: CIImage) throws -> CIImage {
        guard let texture else {
            return processedCiImage
        }
        guard let uiImage = UIImage(named: texture.filename),
              let cgImage = uiImage.cgImage,
              let configuredTexture = try configureTexture(CIImage(cgImage: cgImage), size: processedCiImage.extent.size)
        else {
            throw TextureServiceError.textureDoesntExistOrHasWrongName
        }
        let blendMode = blendMode.ciFilter
        blendMode.backgroundImage = processedCiImage
        blendMode.inputImage = configuredTexture
        if let outputImage = blendMode.outputImage {
            return outputImage
        } else {
            throw TextureServiceError.overlayIssue
        }
    }

    func clear() {
        texture = nil
        alpha = 0.5
        blendMode = .normal
    }
}

private extension TextureService {
    private func configureTexture(_ texture: CIImage, size: CGSize) throws -> CIImage? {
        let resized = resizeImageToAspectFill(image: texture, targetSize: size)
        let alphaFilter = CIFilter.colorMatrix()
        alphaFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: CGFloat(alpha)), forKey: "inputAVector")
        alphaFilter.inputImage = resized
        if let output = alphaFilter.outputImage {
            return output
        } else {
            throw TextureServiceError.alphaIssue
        }
    }

    private func resizeImageToAspectFill(image: CIImage, targetSize: CGSize) -> CIImage {
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
}
