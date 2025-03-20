import Factory

extension Container {
    // MARK: Services
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


    // MARK: Factories

    var imagePropertyFactory: Factory<ImagePropertyFactoryProtocol> {
        Factory(self) { ImagePropertyFactory() }
    }
    var imageEffectFactory: Factory<ImageEffectFactoryProtocol> {
        Factory(self) { ImageEffectFactory() }
    }
}
