import Foundation

/// Кастомные ошибки PhotoEditor
enum PhotoEditorError: LocalizedError {
    /// Ошибка рендера изображения
    case failedToRenderImage
    ///
    case missingProcessedImage
    /// Отсутствует разрешение на доступ к галерее
    case permissionToAccessPhotoLibraryDenied
    /// Ошибка экспорта изображения в галерею
    case failedToExportImageToPhotoLibrary
    /// Неизвестная ошибка
    case unknown
    /// Ошибка фотогалереи
    case photoLibraryError(description: String)
    case histogramRenderIssue
    case downscalingIssue
    case sourceImageIsMissingWhileTryingToUpdateImage
    case processedImageIsMissingWhileTryingToUpdateImage

    // MARK: Computed Properties

    /// User-frienly описание ошибки
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
        case .histogramRenderIssue:
            "Histogram render issue."
        case .downscalingIssue:
            "Issue with downscaling processed image."
        case .sourceImageIsMissingWhileTryingToUpdateImage:
            "Source image is missing while trying to update image."
        case .processedImageIsMissingWhileTryingToUpdateImage:
            "Processed image is missing while trying to update image."
        }
    }
}
