import Foundation
import os

extension Logger {
    /// Создаёт `Logger` с заданной категорией. Для подсистемы используется `bundle ID` приложения
    /// - Parameter category: Строка, которая используется для классификации сообщений
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }

    /// `Logger`, который пишет сообщения с категорией `Default`
    static let `default` = Logger(category: "Default")
}


extension Logger {
    static let photoEditor = Logger(category: "Photo Editor")
}
