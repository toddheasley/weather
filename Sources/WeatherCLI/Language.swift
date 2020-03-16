import Foundation
import ArgumentParser
import Weather

extension Language: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
