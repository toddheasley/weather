import Foundation
import CoreLocation

extension CLLocationManager: CLLocationManagerDelegate {
    static func locate(completion: @escaping (CLLocation?, CLError?) -> Void) {
        Self.completion = completion
        locationManager.delegate = locationManager
        locationManager.requestLocation()
    }
    
    private static let locationManager: CLLocationManager = CLLocationManager()
    private static var completion: ((CLLocation?, CLError?) -> Void)?
    
    // MARK: CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.first {
            Self.completion?(location, nil)
        } else {
            Self.completion?(nil, CLError(.locationUnknown))
        }
        Self.completion = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Self.completion?(nil, (error as? CLError) ?? CLError(.locationUnknown))
        Self.completion = nil
    }
}
