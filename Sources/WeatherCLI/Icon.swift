import Foundation
import Weather

extension Icon {
    var symbol: String {
        switch self {
        case .clearDay:
            return "☀️"
        case .clearNight:
            return "✨"
        case .cloudy, .partlyCloudyNight:
            return "☁️"
        case .fog:
            return "🌫"
        case .partlyCloudyDay:
            return "🌤"
        case .rain:
            return "🌧"
        case .sleet:
            return "🌨"
        case .snow:
            return "❄️"
        case .wind:
            return "💨"
        }
    }
}
