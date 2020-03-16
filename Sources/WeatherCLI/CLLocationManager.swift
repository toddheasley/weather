import Foundation
import CoreLocation
import Combine

extension CLLocationManager: CLLocationManagerDelegate {
    static var publisher: AnyPublisher<CLLocation, CLError> {
        let locationManager: CLLocationManager = Self.locationManager()
        defer {
            locationManager.requestLocation()
        }
        return NotificationCenter.default.publisher(for: Self.locationNotification, object: locationManager)
            .tryMap { notification in
                guard let location: CLLocation = notification.userInfo?["location"] as? CLLocation else {
                    throw((notification.userInfo?["error"] as? Error) ?? CLError(CLError.Code.locationUnknown))
                }
                return location
            }
            .mapError { error in
                return  error as! CLError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private static let locationNotification: Notification.Name = Notification.Name("LocationNotification")
    
    private static func locationManager() -> CLLocationManager {
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.delegate = locationManager
        return locationManager
    }
    
    // MARK: CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.first else {
            return
        }
        NotificationCenter.default.post(name: Self.locationNotification, object: self, userInfo: [
            "location": location
        ])
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NotificationCenter.default.post(name: Self.locationNotification, object: self, userInfo: [
            "error": error
        ])
    }
}
