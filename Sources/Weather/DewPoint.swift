import Foundation

public struct DewPoint {
    public enum Feel: String, CaseIterable, CustomStringConvertible {
        case dry, comfortable, humid
        
        // MARK: CustomStringConvertible
        public var description: String {
            return rawValue
        }
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
        let value: Double = try container.decode(Double.self)
        self.init(temperature: Measurement(value: value, unit: units.temperature))
    }
}
