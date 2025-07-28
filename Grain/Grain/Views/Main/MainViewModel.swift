import Factory
import PhotosUI
import SwiftUI

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

    var showErrorAlert = false {
        didSet {
            if !showErrorAlert {
                photoEditor.errorMessage = nil
            }
        }
    }

    // MARK: DI

    @ObservationIgnored @Injected(\.photoEditorService) private var photoEditor
    @ObservationIgnored @Injected(\.dataService) private var dataService

    // MARK: Computed Properties

    var finalImage: Image? {
        photoEditor.finalImage
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

    var hasModifiedValues: Bool {
        hasModifiedProperties || hasModifiedEffects || hasTexture || hasFilter
    }

    func closeImage() {
        selectedItem = nil
        loadFiltersPreviews?.cancel()
        photoEditor.reset()
        dataService.removePreviews()
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
                await dataService.createFiltersPreviews(with: ciImage)
            }
            isLoadingFiltersPreviews = false
        }
    }

    func clearAll() {
        photoEditor.clearAll()
    }
}

// MARK: Filters

extension MainViewModel {

    var hasFilter: Bool {
        photoEditor.hasFilter
    }

    var currentFilter: Filter? {
        photoEditor.currentFilter
    }

    var filtersPreview: [FilterPreview] {
        dataService.filtersPreview
    }

    var filtersCategories: [FiltersCategory] {
        dataService.filtersCategories
    }

    var texturesCategories: [TexturesCategory] {
        dataService.texturesCategories
    }

    func applyFilter(_ newFilter: Filter) {
        photoEditor.applyFilter(newFilter)
    }

    func applyRandomFilter() {
        let filters = dataService.filtersCategories.flatMap(\.filters)
        guard let randomElement = filters.randomElement() else {
            return
        }
        applyFilter(randomElement)
    }

    func removeFilter() {
        photoEditor.removeFilter()
    }
}

// MARK: Image properties

extension MainViewModel {
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

    var hasModifiedProperties: Bool {
        photoEditor.hasModifiedProperties
    }

    func resetSettings() {
        photoEditor.resetImageProperties()
    }
}

// MARK: Textures

extension MainViewModel {
    var currentTexture: Texture? {
        photoEditor.texture
    }

    var hasTexture: Bool {
        photoEditor.hasTexture
    }

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

    func applyTexture(_ newTexture: Texture) {
        photoEditor.applyTexture(newTexture)
    }

    func applyRandomTexture() {
        let textures = dataService.texturesCategories.flatMap(\.textures)
        guard let randomElement = textures.randomElement() else {
            return
        }
        applyTexture(randomElement)
    }

    func removeTexture() {
        photoEditor.removeTexture()
    }
}

// MARK: Effects

extension MainViewModel {
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

    var hasModifiedEffects: Bool {
        photoEditor.hasModifiedEffects
    }

    func resetEffects() {
        photoEditor.resetEffects()
    }
}
