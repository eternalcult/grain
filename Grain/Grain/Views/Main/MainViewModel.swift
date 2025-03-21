import PhotosUI
import SwiftUI

// TODO: Sort, add extensions for more readable format
@Observable
final class MainViewModel {
    // MARK: Properties

    var loadFiltersPreviews: Task<Void, Never>?
    var selectedItem: PhotosPickerItem?
    var showsFilteredImage = true
    var showsFilters: Bool = false
    var showsSettings = true
    var showsEffects = false
    var showsTextures = false
    var showsHistogram = false
    var isLoadingFiltersPreviews: Bool = false
    var showsPalette = false

    var filtersPreview: [FilterPreview] = []

    var showErrorAlert = false {
        didSet {
            if !showErrorAlert {
                photoEditor.errorMessage = nil
            }
        }
    }

    private var photoEditor: PhotoEditor

    // MARK: Computed Properties

    var finalImage: Image? {
        photoEditor.finalImage
    }

    var texture: Texture? {
        photoEditor.texture
    }

    var currentFilter: Filter? {
        photoEditor.currentFilter
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

    var hasModifiedProperties: Bool {
        photoEditor.hasModifiedProperties
    }

    var brightness: ImagePropertyProtocol {
        get {
            photoEditor.brightness
        }
        set {
            photoEditor.brightness = newValue
        }
    }

    var contrast: ImagePropertyProtocol {
        get {
            photoEditor.contrast
        }
        set {
            photoEditor.contrast = newValue
        }
    }

    var saturation: ImagePropertyProtocol {
        get {
            photoEditor.saturation
        }
        set {
            photoEditor.saturation = newValue
        }
    }

    var exposure: ImagePropertyProtocol {
        get {
            photoEditor.exposure
        }
        set {
            photoEditor.exposure = newValue
        }
    }

    var vibrance: ImagePropertyProtocol {
        get {
            photoEditor.vibrance
        }
        set {
            photoEditor.vibrance = newValue
        }
    }

    var highlights: ImagePropertyProtocol {
        get {
            photoEditor.highlights
        }
        set {
            photoEditor.highlights = newValue
        }
    }

    var shadows: ImagePropertyProtocol {
        get {
            photoEditor.shadows
        }
        set {
            photoEditor.shadows = newValue
        }
    }

    var temperature: ImagePropertyProtocol {
        get {
            photoEditor.temperature
        }
        set {
            photoEditor.temperature = newValue
        }
    }

    var tint: ImagePropertyProtocol {
        get {
            photoEditor.tint
        }
        set {
            photoEditor.tint = newValue
        }
    }

    var gamma: ImagePropertyProtocol {
        get {
            photoEditor.gamma
        }
        set {
            photoEditor.gamma = newValue
        }
    }

    var noiseReduction: ImagePropertyProtocol {
        get {
            photoEditor.noiseReduction
        }
        set {
            photoEditor.noiseReduction = newValue
        }
    }

    var sharpness: ImagePropertyProtocol {
        get {
            photoEditor.sharpness
        }
        set {
            photoEditor.sharpness = newValue
        }
    }

    // MARK: Texture

    var textureBlendMode: BlendMode {
        get {
            photoEditor.textureBlendMode
        } set {
            photoEditor.textureBlendMode = newValue
        }
    }

    var textureAlpha: Float {
        get {
            photoEditor.textureAlpha
        } set {
            photoEditor.textureAlpha = newValue
        }
    }

    var hasTexture: Bool {
        photoEditor.hasTexture
    }

    // MARK: Effects

    var vignette: ImageEffectProtocol {
        get {
            photoEditor.vignette
        } set {
            photoEditor.vignette = newValue
        }
    }

    var bloom: ImageEffectProtocol {
        get {
            photoEditor.bloom
        } set {
            photoEditor.bloom = newValue
        }
    }

    // MARK: Lifecycle

    init(photoEditor: PhotoEditor = PhotoEditorService()) {
        self.photoEditor = photoEditor
    }

    // MARK: Functions

    func resetSettings() {
        photoEditor.resetImageProperties()
    }

    func removeTexture() {
        photoEditor.removeTexture()
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

    func removeFilter() {
        photoEditor.removeFilter()
    }

    func closeImage() {
        selectedItem = nil
        loadFiltersPreviews?.cancel()
        photoEditor.reset()
        DataStorage.shared.filtersPreview = []
    }

    func saveImageToPhotoLibrary() {
        photoEditor.saveImageToPhotoLibrary { result in
            switch result {
            case let .success(success):
                Task {
                    await MainActor.run {
                        HapticFeedback.success()
                    }
                }

            // TODO: Show success alert or snackbar
            case let .failure(failure):
                break // TODO: Show error alert or snackbar
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
            showsFilters = false
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data), let ciImage = CIImage(data: data)
            {
                // TODO: Может вместо того, чтобы отдельно передавать CIImage и ориентацию передавать UIImage?
                photoEditor.updateSourceImage(ciImage, orientation: uiImage.imageOrientation)
                await DataStorage.shared.createFiltersPreviews(with: ciImage)
                filtersPreview = DataStorage.shared.filtersPreview
            }
            isLoadingFiltersPreviews = false
        }
    }
}
