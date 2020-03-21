import Foundation
import ArgumentParser
import Weather

extension Units: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}

extension Units: Printable {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        var lines: [PrintableLine] = []
        lines.append(.label(.custom("units"), rawValue))
        if verbose {
            lines.append(.empty)
            lines.append(.label(.options, nil))
            for units in Units.allCases {
                lines.append(.listItem(units.rawValue, "\(units.description)\(units == Self.auto ? " \(String.default)" : "")", units == self))
            }
            lines.append(.empty)
        }
        return lines
    }
}
