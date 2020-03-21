import Foundation
import ArgumentParser
import Weather

extension Language: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}

extension Language: Printable {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        var lines: [PrintableLine] = []
        lines.append(.label(.custom("language"), rawValue))
        if verbose {
            lines.append(.empty)
            lines.append(.label(.options, nil))
            for language in Self.allCases {
                lines.append(.listItem(language.rawValue, "\(language.description)\(language == Self.auto ? " \(String.default)" : "")", language == self))
            }
            lines.append(.empty)
        }
        return lines
    }
}
