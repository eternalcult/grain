import Foundation

struct FilterCategory: Identifiable {
    let id = UUID()
    let title: String
    let desc: String
    let filters: [Filter]
}
