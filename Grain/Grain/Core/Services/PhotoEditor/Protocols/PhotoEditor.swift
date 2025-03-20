import SwiftUI

/// Все необходимые свойства и методы для реализации PhotoEditorService
protocol PhotoEditor: PhotoEditorImageProperties, PhotoEditorFilters, PhotoEditorTextures, PhotoEditorEffects {
    /// Строка для отображения user-friendly ошибки пользователю
    var errorMessage: String? { get set }
    /// Исходное изображение. Никак не изменяется
    var sourceImage: Image? { get }
    var sourceCiImage: CIImage? { get }
    var finalImage: Image? { get }

    // MARK: Other

    /// Изображение гистограммы.
    var histogram: UIImage? { get }

    // MARK: Functions

    /// Обновить исходное изображение.
    /// - Parameters:
    ///   - image: Новое исходное изображение
    ///   - orientation: Ориентация изображения
    func updateSourceImage(_ image: CIImage, orientation: UIImage.Orientation)

    /// Сохранить изображение в галлерею
    /// - Parameter completion: Результирующий completion
    func saveImageToPhotoLibrary(completion: @escaping (Result<Void, PhotoEditorError>) -> Void)
    /// Удаляет исходное изображение и возвращает все исходные значения
    func reset()
}
