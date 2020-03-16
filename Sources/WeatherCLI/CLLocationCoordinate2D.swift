import Foundation
import CoreLocation
import ArgumentParser

extension CLLocationCoordinate2D: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        let arguments: [String] = argument.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
        guard arguments.count == 2,
            let latitude: CLLocationDegrees = CLLocationDegrees(argument: arguments[0]),
            let longitude: CLLocationDegrees = CLLocationDegrees(argument: arguments[1]) else {
            return nil
        }
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            return nil
        }
        self = coordinate
    }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return "\(latitude.normalized),\(longitude.normalized)"
    }
}

extension CLLocationDegrees {
    fileprivate var normalized: String {
        let precision: Int = "\(self)".components(separatedBy: ".").last?.count ?? 0
        return String(format: "%.\(min(max(precision, 1), 7))f", self)
    }
}
