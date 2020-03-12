import Foundation

public struct Temperature {
    public let actual: Measurement<UnitTemperature>
    public let apparent: Measurement<UnitTemperature>
    public let date: (actual: Date, apparent: Date)?
}

extension Temperature: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        let actual: Measurement<UnitTemperature> = Measurement(value: try container.decode(Double.self, forKey: .temperature), unit: units.temperature)
        let apparent: Measurement<UnitTemperature> = Measurement(value: try container.decode(Double.self, forKey: .apparentTemperature), unit: units.temperature)
        self.init(actual: actual, apparent: apparent, date: nil)
    }
    
    private enum Key: CodingKey {
        case temperature, apparentTemperature
    }
}
