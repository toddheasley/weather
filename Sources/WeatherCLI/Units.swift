import Foundation
import ArgumentParser
import Weather

extension Units: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}

extension Units: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .us:
            return "United States"
        case .ca:
            return "Canada"
        case .uk2:
            return "United Kingdom"
        case .si:
            return "International"
        }
    }
}
