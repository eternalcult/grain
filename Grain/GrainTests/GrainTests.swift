import XCTest
@testable import Grain

final class PhotoEditorTests: XCTestCase {

    var photoEditor: PhotoEditor!
    var testCiImage: CIImage!

    override func setUpWithError() throws {
        photoEditor = PhotoEditorService()
        testCiImage = CIImage(image: UIImage(named: "preview")!)
    }

    override func tearDownWithError() throws {
        photoEditor = nil
    }

    func testInitState() {
        XCTAssertNil(photoEditor.sourceImage)
        XCTAssertNil(photoEditor.sourceCiImage)
        XCTAssertNil(photoEditor.finalImage)
        XCTAssertNil(photoEditor.histogram)
        XCTAssertNil(photoEditor.errorMessage)
    }

    func testUpdateSourceImage() {
        let orientation = UIImage.Orientation.up

        photoEditor.updateSourceImage(testCiImage, orientation: orientation)

        XCTAssertNotNil(photoEditor.sourceImage)
        XCTAssertNotNil(photoEditor.sourceCiImage)
    }

    func testReset() {
        // Устанавливаем значения
        photoEditor.updateSourceImage(testCiImage, orientation: .up)
        photoEditor.applyFilter(mockValidFilter)
        photoEditor.applyTexture(mockValidTexture)

        XCTAssertNotNil(photoEditor.sourceImage)
        XCTAssertNotNil(photoEditor.sourceCiImage)
        XCTAssertNotNil(photoEditor.histogram)
        XCTAssertTrue(photoEditor.hasFilter)
        XCTAssertTrue(photoEditor.hasTexture)

        // Сбрасываем состояние
        photoEditor.reset()

        // Проверяем, что значения отсутствуют
        XCTAssertNil(photoEditor.sourceImage)
        XCTAssertNil(photoEditor.sourceCiImage)
        XCTAssertNil(photoEditor.finalImage)
        XCTAssertNil(photoEditor.histogram)
        XCTAssertNil(photoEditor.errorMessage)
        XCTAssertFalse(photoEditor.hasFilter)
        XCTAssertFalse(photoEditor.hasTexture)
    }


}


// MARK: Image Properties
extension PhotoEditorTests {
    func testHasModifiedProperties() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        photoEditor.brightness.current = 2
        XCTAssertTrue(photoEditor.hasModifiedProperties)
        photoEditor.brightness.setToDefault()
        XCTAssertFalse(photoEditor.hasModifiedProperties)
    }

    func testBrightness() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultBrightness = photoEditor.brightness.current
        photoEditor.brightness.current = 10
        XCTAssertNotEqual(defaultBrightness, photoEditor.brightness.current)
        photoEditor.brightness.setToDefault()
        XCTAssertEqual(defaultBrightness, photoEditor.brightness.current)
    }

    func testContrast() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultContrast = photoEditor.contrast.current
        photoEditor.contrast.current = 10
        XCTAssertNotEqual(defaultContrast, photoEditor.contrast.current)
        photoEditor.contrast.setToDefault()
        XCTAssertEqual(defaultContrast, photoEditor.contrast.current)
    }

    func testSaturation() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultSaturation = photoEditor.saturation.current
        photoEditor.saturation.current = 10
        XCTAssertNotEqual(defaultSaturation, photoEditor.saturation.current)
        photoEditor.saturation.setToDefault()
        XCTAssertEqual(defaultSaturation, photoEditor.saturation.current)
    }

    func testExposure() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultExposure = photoEditor.exposure.current
        photoEditor.exposure.current = 10
        XCTAssertNotEqual(defaultExposure, photoEditor.exposure.current)
        photoEditor.exposure.setToDefault()
        XCTAssertEqual(defaultExposure, photoEditor.exposure.current)
    }

    func testVibrance() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultVibrance = photoEditor.vibrance.current
        photoEditor.vibrance.current = 10
        XCTAssertNotEqual(defaultVibrance, photoEditor.vibrance.current)
        photoEditor.vibrance.setToDefault()
        XCTAssertEqual(defaultVibrance, photoEditor.vibrance.current)
    }

    func testHighlights() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultHighlights = photoEditor.highlights.current
        photoEditor.highlights.current = 10
        XCTAssertNotEqual(defaultHighlights, photoEditor.highlights.current)
        photoEditor.highlights.setToDefault()
        XCTAssertEqual(defaultHighlights, photoEditor.highlights.current)
    }

    func testShadows() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultShadows = photoEditor.shadows.current
        photoEditor.shadows.current = 10
        XCTAssertNotEqual(defaultShadows, photoEditor.shadows.current)
        photoEditor.shadows.setToDefault()
        XCTAssertEqual(defaultShadows, photoEditor.shadows.current)
    }

    func testTemperature() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultTemperature = photoEditor.temperature.current
        photoEditor.temperature.current = 10
        XCTAssertNotEqual(defaultTemperature, photoEditor.temperature.current)
        photoEditor.temperature.setToDefault()
        XCTAssertEqual(defaultTemperature, photoEditor.temperature.current)
    }

    func testTint() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultTint = photoEditor.tint.current
        photoEditor.tint.current = 10
        XCTAssertNotEqual(defaultTint, photoEditor.tint.current)
        photoEditor.tint.setToDefault()
        XCTAssertEqual(defaultTint, photoEditor.tint.current)
    }

    func testGamma() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultGamma = photoEditor.gamma.current
        photoEditor.gamma.current = 10
        XCTAssertNotEqual(defaultGamma, photoEditor.gamma.current)
        photoEditor.gamma.setToDefault()
        XCTAssertEqual(defaultGamma, photoEditor.gamma.current)
    }

    func testNoiseReduction() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultNoiseReduction = photoEditor.noiseReduction.current
        photoEditor.noiseReduction.current = 10
        XCTAssertNotEqual(defaultNoiseReduction, photoEditor.noiseReduction.current)
        photoEditor.noiseReduction.setToDefault()
        XCTAssertEqual(defaultNoiseReduction, photoEditor.noiseReduction.current)
    }

    func testSharpness() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        let defaultSharpness = photoEditor.sharpness.current
        photoEditor.sharpness.current = 10
        XCTAssertNotEqual(defaultSharpness, photoEditor.sharpness.current)
        photoEditor.sharpness.setToDefault()
        XCTAssertEqual(defaultSharpness, photoEditor.sharpness.current)
    }

    func testResetImageProperties() {
        XCTAssertFalse(photoEditor.hasModifiedProperties)
        photoEditor.brightness.current = 10
        photoEditor.contrast.current = 10
        photoEditor.saturation.current = 10
        photoEditor.exposure.current = 10
        photoEditor.vibrance.current = 10
        photoEditor.highlights.current = 10
        photoEditor.shadows.current = 10
        photoEditor.temperature.current = 10
        photoEditor.tint.current = 10
        photoEditor.gamma.current = 10
        photoEditor.noiseReduction.current = 10
        photoEditor.sharpness.current = 10
        XCTAssertTrue(photoEditor.hasModifiedProperties)
        photoEditor.resetImageProperties()
        XCTAssertFalse(photoEditor.hasModifiedProperties)
    }
}


// MARK: Filters

extension PhotoEditorTests {

    func testCurrentFilter() {
        XCTAssertNil(photoEditor.currentFilter)
        photoEditor.applyFilter(mockValidFilter)
        XCTAssertNotNil(photoEditor.currentFilter)
        photoEditor.removeFilter()
        XCTAssertNil(photoEditor.currentFilter)
    }

    func testHasFilter() {
        XCTAssertFalse(photoEditor.hasFilter)
        photoEditor.applyFilter(mockValidFilter)
        XCTAssertTrue(photoEditor.hasFilter)
        photoEditor.removeFilter()
        XCTAssertFalse(photoEditor.hasFilter)
    }

    func testRemoveFilter() {
        photoEditor.applyFilter(mockValidFilter)
        XCTAssertNotNil(photoEditor.currentFilter)
        photoEditor.removeFilter()
        XCTAssertNil(photoEditor.currentFilter)
    }

    func testValidFilterApply() {
        photoEditor.applyFilter(mockValidFilter)
        XCTAssertTrue(photoEditor.hasFilter)
    }

    func testResetFilter() {
        photoEditor.applyFilter(mockValidFilter)
        XCTAssertTrue(photoEditor.hasFilter)
        photoEditor.reset()
        XCTAssertFalse(photoEditor.hasFilter)
    }

    // TODO: Применение несуществующего фильтра
}

// MARK: Textures

extension PhotoEditorTests {
    func testBlendMode() {
        XCTAssertEqual(photoEditor.textureBlendMode, .normal)
        photoEditor.textureBlendMode = .color
        XCTAssertEqual(photoEditor.textureBlendMode, .color)
    }

    func testAlpha() {
        photoEditor.textureAlpha = 1
        XCTAssertEqual(photoEditor.textureAlpha, 1)
        photoEditor.textureAlpha = 0.5
        XCTAssertEqual(photoEditor.textureAlpha, 0.5)
    }

    func testCurrentTexture() {
        XCTAssertNil(photoEditor.texture)
        photoEditor.applyTexture(mockValidTexture)
        XCTAssertNotNil(photoEditor.texture)
        photoEditor.removeTexture()
        XCTAssertNil(photoEditor.texture)
    }

    func testHasTexture() {
        XCTAssertFalse(photoEditor.hasTexture)
        photoEditor.applyTexture(mockValidTexture)
        XCTAssertTrue(photoEditor.hasTexture)
        photoEditor.removeTexture()
        XCTAssertFalse(photoEditor.hasTexture)
    }

    func testRemoveTexture() {
        photoEditor.applyTexture(mockValidTexture)
        XCTAssertNotNil(photoEditor.texture)
        photoEditor.removeTexture()
        XCTAssertNil(photoEditor.texture)
    }


    func testValidTextureApply() {
        photoEditor.applyTexture(mockValidTexture)
        XCTAssertTrue(photoEditor.hasTexture)
    }
    // TODO: Применение несуществующей текстуры

    func testResetTexture() {
        photoEditor.applyTexture(mockValidTexture)
        photoEditor.textureAlpha = 0.1
        photoEditor.textureBlendMode = .color
        XCTAssertTrue(photoEditor.hasTexture)
        XCTAssertEqual(photoEditor.textureAlpha, 0.1)
        XCTAssertEqual(photoEditor.textureBlendMode, .color)
        photoEditor.reset()
        XCTAssertFalse(photoEditor.hasTexture)
        XCTAssertEqual(photoEditor.textureAlpha, 0.5)
        XCTAssertEqual(photoEditor.textureBlendMode, .normal)
    }
}

// MARK: Effects

extension PhotoEditorTests {
    func testVignette() {
        let defaultIntensity = photoEditor.vignette.intensity.current
        let defaultRadius = photoEditor.vignette.radius.current
        photoEditor.vignette.intensity.current = 10
        photoEditor.vignette.radius.current = 10
        XCTAssertNotEqual(defaultIntensity, photoEditor.vignette.intensity.current)
        XCTAssertNotEqual(defaultRadius, photoEditor.vignette.radius.current)
        photoEditor.vignette.setToDefault()
        XCTAssertEqual(defaultIntensity, photoEditor.vignette.intensity.current)
        XCTAssertEqual(defaultRadius, photoEditor.vignette.radius.current)
    }

    func testBloom() {
        let defaultIntensity = photoEditor.bloom.intensity.current
        let defaultRadius = photoEditor.bloom.radius.current
        photoEditor.bloom.intensity.current = 10
        photoEditor.bloom.radius.current = 100
        XCTAssertNotEqual(defaultIntensity, photoEditor.bloom.intensity.current)
        XCTAssertNotEqual(defaultRadius, photoEditor.bloom.radius.current)
        photoEditor.bloom.setToDefault()
        XCTAssertEqual(defaultIntensity, photoEditor.bloom.intensity.current)
        XCTAssertEqual(defaultRadius, photoEditor.bloom.radius.current)
    }

    func testResetEffects() {
        // TODO: photoEditor.resetEffects()
    }

    func testGlobalResetEffects() {
        // TODO: photoEditor.reset()
    }
}
