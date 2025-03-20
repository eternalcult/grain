protocol PhotoEditorEffects {
    var vignette: ImageEffectProtocol { get set }
    var bloom: ImageEffectProtocol { get set }
    func resetEffects()
}
