import Factory

extension Container {
    var imagePropertyFactory: Factory<ImagePropertyFactoryProtocol> {
        Factory(self) { ImagePropertyFactory() }
    }

    var imageEffectFactory: Factory<ImageEffectFactoryProtocol> {
        Factory(self) { ImageEffectFactory() }
    }
}
