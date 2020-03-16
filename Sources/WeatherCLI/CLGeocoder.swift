import Foundation
import CoreLocation
import Combine

extension CLGeocoder {
    public static func publisher(coordinate: CLLocationCoordinate2D) -> AnyPublisher<CLPlacemark, CLError> {
        let geocoder: CLGeocoder = CLGeocoder()
        return Future<CLPlacemark, CLError> { handler in
                geocoder.reverseGeocodeLocation(CLLocation(coordinate: coordinate)) { places, error in
                    guard let place: CLPlacemark = places?.first else {
                        handler(.failure((error as? CLError) ?? CLError(.geocodeFoundNoResult)))
                        return
                    }
                    handler(.success(place))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public static func publisher(address: String) -> AnyPublisher<CLPlacemark, CLError> {
        let geocoder: CLGeocoder = CLGeocoder()
        return Future<CLPlacemark, CLError> { handler in
                geocoder.geocodeAddressString(address) { places, error in
                    guard let place: CLPlacemark = places?.first else {
                        handler(.failure((error as? CLError) ?? CLError(.geocodeFoundNoResult)))
                        return
                    }
                    handler(.success(place))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension CLLocation {
    fileprivate convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
