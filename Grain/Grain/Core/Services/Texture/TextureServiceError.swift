import Foundation

enum TextureServiceError: LocalizedError {
    /// Не удается обновить alpha значение текстуры
    case alphaIssue
    /// Текстура не существует или указано не верное название
    case textureDoesntExistOrHasWrongName
    /// Проблема с наложением текстуры
    case overlayIssue

    // MARK: Computed Properties

    /// User-frienly описание ошибки
    var errorDescription: String? {
        switch self {
        case .alphaIssue:
            "Can't update texture's alpha"
        case .textureDoesntExistOrHasWrongName:
            "Texture doesn't exist or has wrong name"
        case .overlayIssue:
            "Can't overlay selected texture"
        }
    }
}
