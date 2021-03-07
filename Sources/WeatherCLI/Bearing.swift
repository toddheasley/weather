import Foundation
import Weather

extension Bearing {
    var symbol: Character {
        switch self {
        case .e:
            return "⬅️"
        case .ene, .ne, .nne:
            return "↙️"
        case .n:
            return "⬇️"
        case .nnw, .nw, .wnw:
            return "↘️"
        case .w:
            return "➡️"
        case .wsw, .sw, .ssw:
            return "↗️"
        case .s:
            return "⬆️"
        case .ese, .se, .sse:
            return "↗️"
        }
    }
}
