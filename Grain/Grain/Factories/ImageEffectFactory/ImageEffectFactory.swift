struct ImageEffectFactory: ImageEffectFactoryProtocol {
    func make(effect: ImageEffectType) -> ImageEffectProtocol {
        switch effect {
        case  .vignette:
            let intensity = ImageEffectIntensity(
                title: "Intensity",
                range: 0 ... 10,
                defaultValue: 0,
                formatStyle: .zeroTo100,
                propertyKey: nil
            )
            let radius = ImageEffectRadius(
                title: "Radius",
                range: 0 ... 2,
                defaultValue: 1,
                formatStyle: .minus100to100,
                propertyKey: nil
            )
            return ImageEffect(intensity: intensity, radius: radius)
        case .bloom:
            let intensity = ImageEffectIntensity(
                title: "Intensity",
                range: 0 ... 1,
                defaultValue: 0,
                formatStyle: .zeroTo100,
                propertyKey: nil
            )
            let radius = ImageEffectRadius(
                title: "Radius",
                range: 0 ... 100,
                defaultValue: 10,
                formatStyle: .zeroTo100,
                propertyKey: nil
            )
            return ImageEffect(intensity: intensity, radius: radius)
        }
    }
}
