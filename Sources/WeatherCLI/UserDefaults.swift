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
    
    var location: CLLocationCoordinate2D? {
        set {
            
        }
        get {
            return nil
        }
    }
}
