import Foundation
import CoreLocation

extension CLGeocoder {
    typealias Location = (coordinate: CLLocationCoordinate2D, description: String?)
    
    static func geocode(coordinate: CLLocationCoordinate2D? = nil, completion: @escaping (Location?, CLError?) -> Void) {
        guard let coordinate: CLLocationCoordinate2D = coordinate else {
            CLLocationManager.locate { location, error in
                guard let coordinate: CLLocationCoordinate2D = location?.coordinate else {
                    DispatchQueue.main.async {
                        completion(nil, error ?? CLError(.locationUnknown))
                    }
                    return
                }
                geocode(coordinate: coordinate, completion: completion)
            }
            return
        }
        geocoder.reverseGeocodeLocation(CLLocation(coordinate: coordinate)) { placemarks, error in
            handle(coordinate: coordinate, placemarks: placemarks, error: error, completion: completion)
        }
    }
    
    static func geocode(address: String, completion: @escaping (Location?, CLError?) -> Void) {
        geocoder.geocodeAddressString(address){ placemarks, error in
            handle(coordinate: nil, placemarks: placemarks, error: error, completion: completion)
        }
    }
    
    private static let geocoder: CLGeocoder = CLGeocoder()
    
    private static func handle(coordinate: CLLocationCoordinate2D?, placemarks: [CLPlacemark]?, error: Error?, completion: (Location?, CLError?) -> Void) {
        guard let coordinate: CLLocationCoordinate2D = coordinate ?? placemarks?.first?.location?.coordinate else {
            completion(nil, (error as? CLError) ?? CLError(.geocodeFoundNoResult))
            return
        }
        completion((coordinate, placemarks?.first?.address), nil)
    }
}

extension CLPlacemark {
    fileprivate var address: String {
        return description.components(separatedBy: " @")[0].components(separatedBy: ", ").dropFirst().joined(separator: ", ")
    }
}

extension CLLocation {
    fileprivate convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
