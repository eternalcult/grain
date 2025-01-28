import Foundation

enum LutsManagerError: LocalizedError {
    case couldntFindFilterFileUrl
    case cubeFileReadingError
    case CIColorCubeFilterCreationFailed
    case filterApplyingFailed

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
