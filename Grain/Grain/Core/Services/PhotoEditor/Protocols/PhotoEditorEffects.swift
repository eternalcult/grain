protocol PhotoEditorEffects {
    var hasModifiedEffects: Bool { get }
    var vignette: ImageEffectProtocol { get set }
    var bloom: ImageEffectProtocol { get set }
    func resetEffects()
}
