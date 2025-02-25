import Foundation

struct FiltersCategory: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let desc: String
    let filters: [Filter]

    enum CodingKeys: String, CodingKey {
        case title
        case desc
        case filters
    }
}
