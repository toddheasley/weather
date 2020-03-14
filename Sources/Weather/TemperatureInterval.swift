import Foundation

public struct TemperatureInterval {
    public let low: Temperature
    public let high: Temperature
    public let min: Temperature
    public let max: Temperature
}

extension TemperatureInterval: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        low = Temperature(actual: Measurement(value: try container.decode(Double.self, forKey: .temperatureLow), unit: units.temperature), apparent: Measurement(value: try container.decode(Double.self, forKey: .apparentTemperatureLow), unit: units.temperature), date: (try container.decode(Date.self, forKey: .temperatureLowTime), try container.decode(Date.self, forKey: .apparentTemperatureLowTime)))
        high = Temperature(actual: Measurement(value: try container.decode(Double.self, forKey: .temperatureHigh), unit: units.temperature), apparent: Measurement(value: try container.decode(Double.self, forKey: .apparentTemperatureHigh), unit: units.temperature), date: (try container.decode(Date.self, forKey: .temperatureHighTime), try container.decode(Date.self, forKey: .apparentTemperatureHighTime)))
        min = Temperature(actual: Measurement(value: try container.decode(Double.self, forKey: .temperatureMin), unit: units.temperature), apparent: Measurement(value: try container.decode(Double.self, forKey: .apparentTemperatureMin), unit: units.temperature), date:(try container.decode(Date.self, forKey: .temperatureMinTime), try container.decode(Date.self, forKey: .apparentTemperatureMinTime)))
        max = Temperature(actual: Measurement(value: try container.decode(Double.self, forKey: .temperatureMax), unit: units.temperature), apparent: Measurement(value: try container.decode(Double.self, forKey: .apparentTemperatureMax), unit: units.temperature), date: (try container.decode(Date.self, forKey: .temperatureMaxTime), try container.decode(Date.self, forKey: .apparentTemperatureMaxTime)))
    }
    
    private enum Key: CodingKey {
        case temperatureHigh, temperatureHighTime, temperatureLow, temperatureLowTime, apparentTemperatureHigh, apparentTemperatureHighTime, apparentTemperatureLow, apparentTemperatureLowTime, temperatureMin, temperatureMinTime, temperatureMax, temperatureMaxTime, apparentTemperatureMin, apparentTemperatureMinTime, apparentTemperatureMax, apparentTemperatureMaxTime
    }
}
