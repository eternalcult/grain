import PhotosUI
import SwiftUI

@Observable
final class MainViewModel {
    // MARK: Properties

    var loadFiltersPreviews: Task<Void, Never>?
    var photoEditor: PhotoEditor // TODO: Private?
    var selectedItem: PhotosPickerItem?
    var showsFilteredImage = true
    var showsFilters: Bool = false
    var showsSettings = true
    var showsEffects = false
    var showsTextures = false
    var showsHistogram = false
    var isLoadingFiltersPreviews: Bool = false
    var showsPalette = false

    // MARK: Computed Properties

    var showErrorAlert = false {
        didSet {
            if !showErrorAlert {
                photoEditor.errorMessage = nil
            }
        }
    }

    var finalImage: Image? {
        photoEditor.finalImage
    }

    var texture: Texture? {
        photoEditor.texture
    }

    var filter: Filter? {
        photoEditor.filter
    }

    var finalCiImage: CIImage? {
        photoEditor.finalCiImage
    }

    var sourceImage: Image? {
        photoEditor.sourceImage
    }

    var histogram: UIImage? {
        photoEditor.histogram
    }

    var errorMessage: String? {
        photoEditor.errorMessage
    }

    var propertiesModified: Bool {
        photoEditor.propertiesModified
    }

    var brightness: ImageProperty {
        get {
            photoEditor.brightness
        }
        set {
            photoEditor.brightness = newValue
        }
    }

    var contrast: ImageProperty {
        get {
            photoEditor.contrast
        }
        set {
            photoEditor.contrast = newValue
        }
    }

    var saturation: ImageProperty {
        get {
            photoEditor.saturation
        }
        set {
            photoEditor.saturation = newValue
        }
    }

    var exposure: ImageProperty {
        get {
            photoEditor.exposure
        }
        set {
            photoEditor.exposure = newValue
        }
    }

    var vibrance: ImageProperty {
        get {
            photoEditor.vibrance
        }
        set {
            photoEditor.vibrance = newValue
        }
    }

    var highlights: ImageProperty {
        get {
            photoEditor.highlights
        }
        set {
            photoEditor.highlights = newValue
        }
    }

    var shadows: ImageProperty {
        get {
            photoEditor.shadows
        }
        set {
            photoEditor.shadows = newValue
        }
    }

    var temperature: ImageProperty {
        get {
            photoEditor.temperature
        }
        set {
            photoEditor.temperature = newValue
        }
    }

    var tint: ImageProperty {
        get {
            photoEditor.tint
        }
        set {
            photoEditor.tint = newValue
        }
    }

    var gamma: ImageProperty {
        get {
            photoEditor.gamma
        }
        set {
            photoEditor.gamma = newValue
        }
    }

    var noiseReduction: ImageProperty {
        get {
            photoEditor.noiseReduction
        }
        set {
            photoEditor.noiseReduction = newValue
        }
    }

    var sharpness: ImageProperty {
        get {
            photoEditor.sharpness
        }
        set {
            photoEditor.sharpness = newValue
        }
    }

    // MARK: Texture

    var textureBlendMode: BlendMode {
        photoEditor.textureBlendMode
    }

    var textureIntensity: Float {
        get {
            photoEditor.textureIntensity
        } set {
            photoEditor.textureIntensity = newValue
        }
    }

    var hasTexture: Bool {
        photoEditor.hasTexture
    }

    // MARK: Effects

    var vignetteIntensity: ImageProperty {
        get {
            photoEditor.vignetteIntensity
        } set {
            photoEditor.vignetteIntensity = newValue
        }
    }

    var vignetteRadius: ImageProperty {
        get {
            photoEditor.vignetteRadius
        } set {
            photoEditor.vignetteRadius = newValue
        }
    }

    // MARK: Lifecycle

    init(photoEditor: PhotoEditor = PhotoEditorService()) {
        self.photoEditor = photoEditor
    }

    // MARK: Functions

    func resetSettings() {
        photoEditor.resetSettings()
    }

    func removeTextureIfNeeded() {
        photoEditor.removeTextureIfNeeded()
    }

    func applyFilter(_ newFilter: Filter) {
        photoEditor.applyFilter(newFilter)
    }

    func applyRandomFilter() {
        let filters = DataStorage.shared.filtersCategories.flatMap(\.filters)
        guard let randomElement = filters.randomElement() else {
            return
        }
        applyFilter(randomElement)
    }

    func applyTexture(_ newTexture: Texture) {
        photoEditor.applyTexture(newTexture)
    }

    func applyRandomTexture() {
        let textures = DataStorage.shared.texturesCategories.flatMap(\.textures)
        guard let randomElement = textures.randomElement() else {
            return
        }
        applyTexture(randomElement)
    }

    func removeFilterIfNeeded() {
        photoEditor.removeFilterIfNeeded()
    }

    func applyTextureBlendMode(to blendMode: BlendMode) {
        photoEditor.applyTextureBlendMode(to: blendMode)
    }

    func closeImage() {
        selectedItem = nil
        loadFiltersPreviews?.cancel()
        photoEditor.reset()
    }

    func saveImageToPhotoLibrary() {
        photoEditor.saveImageToPhotoLibrary { result in
            switch result {
            case let .success(success):
                break // TODO: Show success
            case let .failure(failure):
                break // TODO: Show error
            }
        }
    }

    func prepareForEditing() {
        guard let selectedItem else {
            return
        }
        loadFiltersPreviews?.cancel()
        loadFiltersPreviews = Task {
            isLoadingFiltersPreviews = true
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data), let ciImage = CIImage(data: data)
            {
                // TODO: Может вместо того, чтобы отдельно передавать CIImage и ориентацию передавать UIImage?
                photoEditor.updateSourceImage(ciImage, orientation: uiImage.imageOrientation)
                await DataStorage.shared.updateFiltersPreviews(with: ciImage)
            }
            isLoadingFiltersPreviews = false
        }
    }
}
