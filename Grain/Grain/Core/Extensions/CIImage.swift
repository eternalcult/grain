import CoreImage
import UIKit

extension CIImage {
    func downsample(scaleFactor: CGFloat = 0.5) -> CIImage {
        transformed(by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
    }

    func renderToUIImage(with context: CIContext, orientation: UIImage.Orientation? = .up) -> UIImage? {
        guard let cgImage = context.createCGImage(self, from: self.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: 1, orientation: orientation ?? .up)
    }
}
