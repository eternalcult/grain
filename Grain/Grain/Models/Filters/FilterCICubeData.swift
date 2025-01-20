import Foundation
import SwiftData

@Model
class FilterCICubeData {
    var id: Int
    var dimension: Int
    var cubeData: Data

    init(id: Int, dimension: Int, cubeData: Data) {
        self.id = id
        self.dimension = dimension
        self.cubeData = cubeData
    }
}
