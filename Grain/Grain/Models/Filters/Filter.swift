import Foundation
import CoreImage

struct Filter: Identifiable {
    let id: Int
    let title: String
    /// Название .cube файла
    let filename: String
    let preview: CGImage?

    init(id: Int, title: String, filename: String, preview: CGImage? = nil) {
        self.id = id
        self.title = title
        self.filename = filename
        self.preview = preview
    }
}
