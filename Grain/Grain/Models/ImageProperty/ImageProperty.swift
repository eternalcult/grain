import SwiftUI

struct ImageProperty: ImagePropertyProtocol {
    let title: LocalizedStringKey
    let range: ClosedRange<ImagePropertyValue>
    let defaultValue: ImagePropertyValue
    var current: ImagePropertyValue
    let formatStyle: ImagePropertyFormatStyle
    let propertyKey: String?

    init(
        title: LocalizedStringKey,
        range: ClosedRange<ImagePropertyValue>,
        defaultValue: ImagePropertyValue,
        formatStyle: ImagePropertyFormatStyle,
        propertyKey: String?
    ) {
        self.title = title
        self.range = range
        self.defaultValue = defaultValue
        self.current = defaultValue
        self.formatStyle = formatStyle
        self.propertyKey = propertyKey
    }
}
