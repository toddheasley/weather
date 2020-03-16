import Foundation

public enum Icon: String, CaseIterable, Decodable {
    case clearDay = "clear-day", clearNight = "clear-night", cloudy, fog, partlyCloudyDay = "partly-cloudy-day", partlyCloudyNight = "partly-cloudy-night", rain, sleet, snow, wind
    
    public var isPrecipitation: Bool {
        switch self {
        case .rain, .snow, .sleet:
            return true
        default:
            return false
        }
    }
}

extension Icon: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return rawValue.replacingOccurrences(of: "-", with: " ")
    }
}
