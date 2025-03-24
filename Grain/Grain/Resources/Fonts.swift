import SwiftUI

extension Font {
    /// Montserrat, Bold, 48
    static let h1 = Font.custom("Montserrat-Bold", size: 48)
    /// Montserrat, Bold, 30
    static let h2 = Font.custom("Montserrat-Bold", size: 30)
    /// Montserrat, Bold, 24
    static let h3 = Font.custom("Montserrat-Bold", size: 24)
    /// Montserrat, Bold, 20
    static let h4 = Font.custom("Montserrat-Bold", size: 20)
    /// Montserrat, Bold, 16
    static let h5 = Font.custom("Montserrat-Bold", size: 16)
    /// Montserrat, Bold, 12
    static let h6 = Font.custom("Montserrat-Bold", size: 12)

    /// Montserrat, Regular, 16
    static let text = Font.custom("Montserrat-Regular", size: 16)
    /// Montserrat, Regular, 14
    static let textSub = Font.custom("Montserrat-Regular", size: 14)
    /// Montserrat, Bold, 24
    static let buttonL = Font.custom("Montserrat-Bold", size: 24)
    /// Montserrat, Bold, 20
    static let buttonM = Font.custom("Montserrat-Bold", size: 20)
    /// Montserrat, Bold, 16
    static let buttonS = Font.custom("Montserrat-Bold", size: 16)

    enum CustomWeight {
        case regular
        case bold
    }

    static func custom(size: CGFloat, weight: CustomWeight = .regular) -> Font {
        switch weight {
        case .regular:
            Font.custom("Montserrat-Regular", size: size)
        case .bold:
            Font.custom("Montserrat-Bold", size: size)
        }
    }
}
