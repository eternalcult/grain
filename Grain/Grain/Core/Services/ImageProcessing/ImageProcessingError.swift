import SwiftUI

enum ImageProcessingError: LocalizedError {
    case propertyKeyIsMissing(propertyName: LocalizedStringKey)
    case cantUpdateProperty(propertyName: LocalizedStringKey)
    case bloomEffectCantBeApplied
    case HSOutputIssue
    case temperatureAndTintOutputIssue
    case vignetteOutputIssue
    case currentCiImageIsMissing

    // MARK: Computed Properties

    /// User-frienly описание ошибки
    var errorDescription: String? {
        switch self {
        case let .propertyKeyIsMissing(propertyName):
            "Property key is missing for \(propertyName)"
        case let .cantUpdateProperty(propertyName):
            "Can't update the \(propertyName) property"
        case .bloomEffectCantBeApplied:
            "Bloom effect can't be applied"
        case .HSOutputIssue:
            "HS output issue"
        case .temperatureAndTintOutputIssue:
            "Temperature and tint output issue"
        case .vignetteOutputIssue:
            "Vignette output issue"
        case .currentCiImageIsMissing:
            "Current CIImage is missing"
        }
    }
}
