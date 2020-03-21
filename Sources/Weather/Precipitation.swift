import Foundation

public struct Precipitation {
    public enum Phase: String, CaseIterable, Decodable {
        case none, rain, snow, sleet
    }
    
    public enum Severity: CaseIterable {
        case none, trace, light, medium, heavy
    }
    
    public let phase: Phase
    public let accumulation: Measurement<UnitLength>?
    public let intensity: Measurement<UnitLength>?
    public let max: (intensity: Measurement<UnitLength>, date: Date)?
    public let probability: Double?
    
    public var severity: Severity {
        guard phase != .none, (probability ?? 0.0) > 0.25,
            let intensity: Measurement<UnitLength> = intensity else {
            return .none
        }
        if intensity > Measurement(value: 0.3, unit: UnitLength.inches) {
            return .heavy
        } else if intensity > Measurement(value: 0.1, unit: UnitLength.inches) {
            return .medium
        } else if intensity > Measurement(value: 0.02, unit: UnitLength.inches) {
            return .light
        } else {
            return .trace
        }
    }
}

extension Precipitation: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let units: Units = try decoder.units()
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        phase = (try? container.decode(Phase.self, forKey: .precipType)) ?? .none
        if let value: Double = try? container.decode(Double.self, forKey: .precipAccumulation) {
            accumulation = Measurement(value: value, unit: units.accumulation)
        } else {
            accumulation = nil
        }
        if let value: Double = try? container.decode(Double.self, forKey: .precipIntensity) {
            intensity = Measurement(value: value, unit: units.accumulation)
        } else {
            intensity = nil
        }
        if let value: Double = try? container.decode(Double.self, forKey: .precipIntensityMax),
            let time: TimeInterval = try? container.decode(Double.self, forKey: .precipIntensityMaxTime)  {
            max = (Measurement(value: value, unit: units.accumulation), Date(timeIntervalSince1970: time))
        } else {
            max = nil
        }
        probability = try? container.decode(Double.self, forKey: .precipProbability)
    }
    
    private enum Key: CodingKey {
        case precipType, precipAccumulation, precipIntensity, precipIntensityMax, precipIntensityMaxTime, precipProbability
    }
}
