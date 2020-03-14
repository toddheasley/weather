import Foundation

public struct Point {
    public let date: Date
    public let temperature: Temperature?
    public let temperatureInterval: TemperatureInterval?
    public let precipitation: Precipitation?
    public let cloudCover: Double?
    public let dewPoint: DewPoint?
    public let humidity: Double?
    public let nearestStorm: (distance: Measurement<UnitLength>, bearing: Bearing)?
    public let ozone: Double?
    public let pressure: Measurement<UnitPressure>?
    public let visibility: Measurement<UnitLength>?
    public let wind: Wind?
    public let uvIndex: UVIndex?
    public let sun: DateInterval?
    public let moonPhase: MoonPhase?
    public let summary: String?
    public let icon: Icon?
}

extension Point: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        date = try container.decode(Date.self, forKey: .time)
        temperature = try? Temperature(from: decoder)
        temperatureInterval = try? TemperatureInterval(from: decoder)
        precipitation = try? Precipitation(from: decoder)
        cloudCover = try? container.decode(Double.self, forKey: .cloudCover)
        dewPoint = try? container.decode(DewPoint.self, forKey: .dewPoint)
        humidity = try? container.decode(Double.self, forKey: .humidity)
        if let value: Double = try? container.decode(Double.self, forKey: .nearestStormDistance),
            let bearing = try? container.decode(Bearing.self, forKey: .nearestStormBearing) {
            nearestStorm = (Measurement(value: value, unit: units.distance), bearing)
        } else {
            nearestStorm = nil
        }
        ozone = try? container.decode(Double.self, forKey: .ozone)
        if let value: Double = try? container.decode(Double.self, forKey: .pressure) {
            pressure = Measurement(value: value, unit: units.pressure)
        } else {
            pressure = nil
        }
        if let value: Double = try? container.decode(Double.self, forKey: .visibility) {
            visibility = Measurement(value: value, unit: units.distance)
        } else {
            visibility = nil
        }
        wind = try? Wind(from: decoder)
        uvIndex = try? UVIndex(from: decoder)
        if let start: Date = try? container.decode(Date.self, forKey: .sunriseTime), let end: Date = try? container.decode(Date.self, forKey: .sunsetTime), end > start {
            sun = DateInterval(start: start, end: end)
        } else {
            sun = nil
        }
        moonPhase = try? container.decode(MoonPhase.self, forKey: .moonPhase)
        summary = try? container.decode(String.self, forKey: .summary)
        icon = try? container.decode(Icon.self, forKey: .icon)
    }
    
    private enum Key: CodingKey {
        case time, cloudCover, dewPoint, humidity, nearestStormDistance, nearestStormBearing, ozone, pressure, visibility, sunriseTime, sunsetTime, moonPhase, summary, icon
    }
}
