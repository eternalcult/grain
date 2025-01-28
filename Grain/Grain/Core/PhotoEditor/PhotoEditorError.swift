import Foundation

enum PhotoEditorError: LocalizedError {
    case failedToRenderImage
    case missingProcessedImage
    case permissionToAccessPhotoLibraryDenied
    case failedToExportImageToPhotoLibrary
    case textureDoesntExistOrHasWrongName
    case unknown
    case photoLibraryError(description: String)

    var errorDescription: String? {
        switch self {
        case .failedToRenderImage:
            return "Failed to render image."
        case .missingProcessedImage:
            return "Image is missing."
        case .permissionToAccessPhotoLibraryDenied:
            return "Permission to access photo library denied."
        case .failedToExportImageToPhotoLibrary:
            return "Failed to save image to photo library."
        case .unknown:
            return "Unknown error."
        case let .photoLibraryError(description):
            return description
        case .textureDoesntExistOrHasWrongName:
            return "Texture doesn't exist or has wrong name"
        }
    }
}
