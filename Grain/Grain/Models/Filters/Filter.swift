import CoreImage
import Foundation

struct Filter: Identifiable {
    // MARK: Properties

    let id: Int
    let title: String
    let desc: String?
    /// Название .cube файла
    let filename: String
    let preview: CGImage?

    // MARK: Lifecycle

    init(id: Int, title: String, desc: String? = nil, filename: String, preview: CGImage? = nil) {
        self.id = id
        self.title = title
        self.desc = desc
        self.filename = filename
        self.preview = preview
    }
}
