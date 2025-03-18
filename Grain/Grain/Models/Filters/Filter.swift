import CoreImage
import Foundation

struct Filter: Identifiable, Decodable {
    let id: Int
    let title: String
    let desc: String?
    /// Название .cube файла
    let filename: String
}
