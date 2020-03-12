import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    public static let null: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}

extension CLLocationCoordinate2D: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        let latitude: Double = try container.decode(Double.self, forKey: .latitude)
        let longitude: Double = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum Key: CodingKey {
        case latitude, longitude
    }
}
