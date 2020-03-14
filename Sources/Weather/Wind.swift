import Foundation

public struct Wind {
    public let bearing: Bearing
    public let speed: Measurement<UnitSpeed>
    public let gust: Measurement<UnitSpeed>
    public let date: Date?
}

extension Wind: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        bearing = try container.decode(Bearing.self, forKey: .windBearing)
        speed = Measurement(value: try container.decode(Double.self, forKey: .windSpeed), unit: units.speed)
        gust = Measurement(value: try container.decode(Double.self, forKey: .windGust), unit: units.speed)
        date = try? container.decode(Date.self, forKey: .windGustTime)
    }
    
    private enum Key: CodingKey {
        case windBearing, windSpeed, windGust, windGustTime
    }
}
