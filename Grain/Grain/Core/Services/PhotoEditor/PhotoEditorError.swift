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
    /// Текстура не существует или указано не верное название
    case textureDoesntExistOrHasWrongName // TODO: Переместить в ошибки TextureSevice
    /// Неизвестная ошибка
    case unknown
    /// Ошибка фотогалереи
    case photoLibraryError(description: String)

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
        case .textureDoesntExistOrHasWrongName:
            "Texture doesn't exist or has wrong name"
        }
    }
}
