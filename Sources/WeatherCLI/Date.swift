import Foundation
import ArgumentParser

extension Date: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        guard let timeInterval: TimeInterval = TimeInterval(argument: argument) else {
            return nil
        }
        self = Date(timeIntervalSince1970: timeInterval)
    }
}
