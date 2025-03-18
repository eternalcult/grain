import Foundation

/// Кастомные ошибки LutsManager
enum LutsManagerError: LocalizedError {
    /// .cube файл не найден
    case couldntFindFilterFileUrl
    /// Ошибка чтения .cube файла
    case cubeFileReadingError
    /// Ошибка создания CIColorCube фильтра
    case CIColorCubeFilterCreationFailed
    /// Ошибки применения фильтра к изображению
    case filterApplyingFailed

    // MARK: Computed Properties

    /// User-frienly описание ошибки
    var errorDescription: String? {
        switch self {
        case .couldntFindFilterFileUrl:
            "Couldn't find filter file url"
        case .cubeFileReadingError:
            "Cube file reading error."
        case .CIColorCubeFilterCreationFailed:
            "CIColorCube filter creation failed."
        case .filterApplyingFailed:
            "Filter applying failed."
        }
    }
}
