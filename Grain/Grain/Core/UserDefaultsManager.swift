import Foundation

enum UserDefaultsKey: String {
    case launchCount
}

final class UserDefaultsManager {
     static let shared = UserDefaultsManager()

     private init() {}

     func set(value: Any?, forKey: UserDefaultsKey) {
         UserDefaults.standard.set(value, forKey: forKey.rawValue)
     }

     func bool(for key: UserDefaultsKey) -> Bool {
         UserDefaults.standard.bool(forKey: key.rawValue)
     }

     func int(for key: UserDefaultsKey) -> Int {
         UserDefaults.standard.integer(forKey: key.rawValue)
     }

     func string(for key: UserDefaultsKey) -> String? {
         UserDefaults.standard.string(forKey: key.rawValue)
     }

     func array(for key: UserDefaultsKey) -> [Any]? {
         UserDefaults.standard.array(forKey: key.rawValue)
     }

     func data(for key: UserDefaultsKey) -> Data? {
         UserDefaults.standard.data(forKey: key.rawValue)
     }

     func double(for key: UserDefaultsKey) -> Double {
         UserDefaults.standard.double(forKey: key.rawValue)
     }

     func float(for key: UserDefaultsKey) -> Float {
         UserDefaults.standard.float(forKey: key.rawValue)
     }

     func dict(for key: UserDefaultsKey) -> [String: Any]? {
         UserDefaults.standard.dictionary(forKey: key.rawValue)
     }

     func dictWithValues(for keys: [UserDefaultsKey]) -> [String: Any] {
         UserDefaults.standard.dictionaryWithValues(forKeys: keys.map { $0.rawValue })
     }

     func stringArray(for key: UserDefaultsKey) -> [String]? {
         UserDefaults.standard.stringArray(forKey: key.rawValue)
     }

     func object(for key: UserDefaultsKey) -> Any? {
         UserDefaults.standard.object(forKey: key.rawValue)
     }

     func url(for key: UserDefaultsKey) -> URL? {
         UserDefaults.standard.url(forKey: key.rawValue)
     }
}
