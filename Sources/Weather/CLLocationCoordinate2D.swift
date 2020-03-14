import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    public static let null: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}

extension CLLocationCoordinate2D: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        self.init(latitude: try container.decode(Double.self, forKey: .latitude), longitude: try container.decode(Double.self, forKey: .longitude))
    }
    
    private enum Key: CodingKey {
        case latitude, longitude
    }
}
