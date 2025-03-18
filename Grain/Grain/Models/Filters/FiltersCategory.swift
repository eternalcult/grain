import Foundation

struct FiltersCategory: Identifiable, Decodable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case title
        case desc
        case filters
    }

    // MARK: Properties

    let id = UUID()
    let title: String
    let desc: String
    let filters: [Lut]
}
