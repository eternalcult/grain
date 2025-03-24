import Foundation

/// Кастомные ошибки FilterService
enum FilterServiceError: LocalizedError {
    case invalidFilterFileURL
    /// Ошибки применения фильтра к изображению
    case filterApplyingFailed

    // MARK: Computed Properties

    /// User-frienly описание ошибки
    var errorDescription: String? {
        switch self {
        case .invalidFilterFileURL:
            "Invalid filter file URL"
        case .filterApplyingFailed:
            "Filter applying failed."
        }
    }
}
