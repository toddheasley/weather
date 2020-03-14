import Foundation

public struct Flags {
    public let units: Units
    public let sources: [Source]
    public let nearestStation: Measurement<UnitLength>?
    public let isUnavailable: Bool
}

extension Flags: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        units = try container.decode(Units.self, forKey: .units)
        sources = try container.decode([Source].self, forKey: .sources).map { source in
            return Source(name: source.name, stations: try? container.decode([String].self, forKey: .stations(source: source.name)))
        }
        nearestStation = Measurement(value: try container.decode(Double.self, forKey: .nearestStation) , unit: units.distance)
        isUnavailable = (try? container.decode(String.self, forKey: .unavailable)) != nil
    }
    
    private enum Key: CodingKey {
        case sources, stations(source: String), nearestStation, units, unavailable
        
        // MARK: CodingKey
        var stringValue: String {
            switch self {
            case .sources:
                return "sources"
            case .stations(let source):
                return "\(source)-stations"
            case .nearestStation:
                return "nearest-station"
            case .units:
                return "units"
            case .unavailable:
                return "darksky-unavailable"
            }
        }
        
        init?(stringValue: String) {
            return nil
        }
    }
}
