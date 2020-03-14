import Foundation

public struct DewPoint {
    public enum Feel: String, CaseIterable {
        case dry, comfortable, humid
    }
    
    public let temperature: Measurement<UnitTemperature>
    
    public var feel: Feel {
        if temperature < Measurement(value: 50.0, unit: UnitTemperature.fahrenheit) {
            return .dry
        } else if temperature < Measurement(value: 64.0, unit: UnitTemperature.fahrenheit) {
            return .comfortable
        } else {
            return .humid
        }
    }
}

extension DewPoint: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        temperature = Measurement(value: try container.decode(Double.self), unit: units.temperature)
    }
}
