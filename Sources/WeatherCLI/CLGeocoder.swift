import Foundation
import CoreLocation

extension CLGeocoder {
    struct Location: CustomStringConvertible, Printable {
        let coordinate: CLLocationCoordinate2D
        let address: String?
        
        fileprivate init(coordinate: CLLocationCoordinate2D, address: String?) {
            self.coordinate = coordinate
            self.address = !(address ?? "").isEmpty ? address : nil
        }
        
        // MARK: CustomStringConvertible
        var description: String {
            return address ?? coordinate.description
        }
        
        // MARK: Printable
        func printableLines(verbose: Bool) -> [PrintableLine] {
            var lines: [PrintableLine] = []
            lines.append(.label("location", coordinate.description))
            if verbose, let address: String = address {
                lines.append(.empty)
                lines.append(.discussion(address))
                lines.append(.empty)
            }
            return lines
        }
    }
    
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
    
    private static func handle(coordinate: CLLocationCoordinate2D?, placemarks: [CLPlacemark]?, error: Error?, completion: @escaping (Location?, CLError?) -> Void) {
        guard let coordinate: CLLocationCoordinate2D = coordinate ?? placemarks?.first?.location?.coordinate else {
            DispatchQueue.main.async {
                completion(nil, (error as? CLError) ?? CLError(.geocodeFoundNoResult))
            }
            return
        }
        DispatchQueue.main.async {
            completion(Location(coordinate: coordinate, address: placemarks?.first?.address), nil)
        }
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
