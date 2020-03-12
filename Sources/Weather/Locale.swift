import Foundation

extension Locale {
    public var language: Language? {
        if languageCode == Language.zh.rawValue, scriptCode == "Hant" {
            return .zht
        }
        return Language(rawValue: languageCode ?? "")
    }
}
