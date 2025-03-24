import Factory
import SwiftData

extension Container {
    var photoEditorService: Factory<PhotoEditor> {
        Factory(self) { PhotoEditorService() }
    }

    var imageProcessingService: Factory<ImageProcessingServiceProtocol> {
        Factory(self) { ImageProcessingService() }
    }

    var filterService: Factory<FilterServiceProtocol> {
        Factory(self) { FilterService() }
    }

    var textureService: Factory<TextureServiceProtocol> {
        Factory(self) { TextureService() }
    }

    var lutsManager: Factory<LutsManagerProtocol> {
        Factory(self) { LutsManager() }
    }

    var dataService: Factory<DataStorageProtocol> {
        Factory(self) { DataStorageService() }.singleton
    }

    var swiftDataService: Factory<SwiftDataProtocol> {
        let container: ModelContainer

        do {
            let schema = Schema([FilterCICubeData.self])
            container = try ModelContainer(for: schema)
        } catch {
            fatalError("Ошибка при создании контейнера: \(error)") // TODO: Handle Errors
        }

        let context = ModelContext(container)
        return Factory(self) { SwiftDataService(context: context) }
    }
}
