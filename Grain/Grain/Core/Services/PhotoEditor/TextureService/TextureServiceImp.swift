import UIKit
import CoreImage

final class TextureServiceImp: TextureService { // TODO: TextureService protocol
    private(set) var texture: Texture?
    private(set) var textureBlendMode: BlendMode = .normal
    private(set) var textureAlpha: Float = 0.5

    var hasTexture: Bool {
        texture != nil
    }


    func updateAlpha(to newValue: Float) {
        textureAlpha = newValue
    }

    func updateTexture(to newTexture: Texture, completion: (Bool) -> Void) {
        if texture?.id != newTexture.id {
            texture = newTexture
            completion(true)
        }
        completion(false)
    }

    func updateTextureBlendMode(to newBlendMode: BlendMode) {
        if textureBlendMode != newBlendMode {
            textureBlendMode = newBlendMode
        }
    }

    func clear() {
        texture = nil
        textureAlpha = 0.5
        textureBlendMode = .normal
    }

    func overlayTexture(to processedCiImage: CIImage?) -> Result<CIImage, Error> {
        do {
            guard let texture,
                  let uiImage = UIImage(named: texture.filename),
                  let cgImage = uiImage.cgImage,
                  let processedCiImage,
                  let configuredTexture = configureTexture(CIImage(cgImage: cgImage), size: processedCiImage.extent.size)
            else {
                throw PhotoEditorError.textureDoesntExistOrHasWrongName
            }
            let blendMode = textureBlendMode.ciFilter
            blendMode.backgroundImage = processedCiImage
            blendMode.inputImage = configuredTexture
            if let outputImage = blendMode.outputImage {
                return .success(outputImage)
            } else {
                throw PhotoEditorError.unknown // TODO: Добавить тип ошибки
            }
        } catch {
            return .failure(error)
        }
    }
}

private extension TextureServiceImp {
    private func updateTextureIntensity(of texture: CIImage, to alpha: CGFloat) -> CIImage? {
        let alphaFilter = CIFilter.colorMatrix()
        alphaFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: alpha), forKey: "inputAVector")
        alphaFilter.inputImage = texture
        return alphaFilter.outputImage
    }

    private func configureTexture(_ texture: CIImage, size: CGSize) -> CIImage? { // TODO: Refactor
        if let resized = resizeImageToAspectFill(image: texture, targetSize: size) {
            return updateTextureIntensity(of: resized, to: CGFloat(textureAlpha))
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
