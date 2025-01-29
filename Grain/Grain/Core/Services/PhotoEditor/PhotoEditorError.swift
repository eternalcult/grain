import Foundation

enum PhotoEditorError: LocalizedError {
    case failedToRenderImage
    case missingProcessedImage
    case permissionToAccessPhotoLibraryDenied
    case failedToExportImageToPhotoLibrary
    case textureDoesntExistOrHasWrongName
    case unknown
    case photoLibraryError(description: String)

    // MARK: Computed Properties

    var errorDescription: String? {
        switch self {
        case .failedToRenderImage:
            "Failed to render image."
        case .missingProcessedImage:
            "Image is missing."
        case .permissionToAccessPhotoLibraryDenied:
            "Permission to access photo library denied."
        case .failedToExportImageToPhotoLibrary:
            "Failed to save image to photo library."
        case .unknown:
            "Unknown error."
        case let .photoLibraryError(description):
            description
        case .textureDoesntExistOrHasWrongName:
            "Texture doesn't exist or has wrong name"
        }
    }
}
