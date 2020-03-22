import Foundation
import Weather

extension Icon {
    var fill: Character {
        return isPrecipitation ? "🟦" : "⬜️"
    }
    
    var symbol: Character {
        switch self {
        case .clearDay, .clearNight:
            return "☀️"
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
