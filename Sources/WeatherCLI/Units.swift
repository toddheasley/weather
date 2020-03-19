import Foundation
import ArgumentParser
import Weather

extension Units: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
