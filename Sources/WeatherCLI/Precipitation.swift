import Foundation
import Weather

extension Precipitation.Phase {
    
}

extension Precipitation.Severity {
    static var scale: Int {
        return allCases.count - 1
    }
    
    var value: Int {
        for (value, severity) in Self.allCases.enumerated() {
            guard severity == self else {
                continue
            }
            return value
        }
        return 0
    }
}
