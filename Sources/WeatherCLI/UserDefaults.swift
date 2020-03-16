import Foundation
import CoreLocation
import Weather

extension UserDefaults {
    var language: Weather.Language? {
        set {
            set(newValue?.rawValue, forKey: "language")
        }
        get {
            return Weather.Language(rawValue: string(forKey: "language") ?? "")
        }
    }
    
    var units: Weather.Units? {
        set {
            set(newValue?.rawValue, forKey: "units")
        }
        get {
            return Weather.Units(rawValue: string(forKey: "units") ?? "")
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        set {
            set(newValue?.description, forKey: "coordinate")
        }
        get {
            return CLLocationCoordinate2D(argument: string(forKey: "coordinate") ?? "")
        }
    }
}
