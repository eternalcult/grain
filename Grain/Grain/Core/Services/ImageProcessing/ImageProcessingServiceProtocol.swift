import CoreImage

protocol ImageProcessingServiceProtocol {
    var hasModifiedProperties: Bool {get}

    var brightness: ImageProperty{ get set }
    var contrast: ImageProperty{ get set }
    var saturation: ImageProperty{ get set }
    var exposure: ImageProperty{ get set }
    var vibrance: ImageProperty{ get set }
    var highlights: ImageProperty{ get set }
    var shadows: ImageProperty{ get set }
    var temperature: ImageProperty{ get set }
    var tint: ImageProperty{ get set }
    var gamma: ImageProperty{ get set }
    var noiseReduction: ImageProperty{ get set }
    var sharpness: ImageProperty { get set }

    func updateProperties(to processedCiImage: CIImage?) -> CIImage?
    func reset()
}
