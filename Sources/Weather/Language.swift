import Foundation

public enum Language: String, CaseIterable, Decodable {
    case ar, az, be, bg, bn, bs, ca, cs, da, de, el, en, eo, es, et, fi, fr, he, hi, hr, hu, id, `is`, it, ja, ka, kn, ko, kw, lv, ml, mr, nb, nl, no, pa, pig = "x-pig-latin", pl, pt, ro, ru, sk, sl, sr, sv, ta, te, tet, tr, uk, ur, zh, zht = "zh-tw"
    
    public static let auto: Language = .en
}

extension Language: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return Locale.current.localizedString(forLanguageCode: rawValue) ?? ""
    }
}
