import Foundation
import SwiftData

@Model
class FilterCICubeData {
    // MARK: Properties

    var id: Int
    var dimension: Int
    var cubeData: Data

    // MARK: Lifecycle

    init(id: Int, dimension: Int, cubeData: Data) {
        self.id = id
        self.dimension = dimension
        self.cubeData = cubeData
    }
}
