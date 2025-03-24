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

    var dataService: Factory<DataStorageProtocol> {
        Factory(self) { DataStorageService() }.singleton
    }
}
