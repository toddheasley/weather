import Foundation

protocol Printable {
    func printableLines(verbose: Bool) -> [PrintableLine]
}

extension Printable {
    func print(verbose: Bool = false) {
        Swift.print(printableLines(verbose: verbose).map { line in
            return line.description
        }.joined(separator: .newLine))
    }
}

enum PrintableLine: CustomStringConvertible {
    case label(PrintableLabel, String? = nil)
    case listItem(String, String? = nil, Bool = false)
    case barGraph(PrintableBarGraph)
    case lineGraph(String, PrintableLineGraph, String? = nil)
    case discussion(String)
    case empty
    
    // MARK: CustomStringConvertible
    var description: String {
        switch self {
        case .label(let label, let string):
            return label.description.joined(with: string)
        case .listItem(let string, let string2, let selected):
            return "\(selected ? "\(String.bullet)" : " ") \(string)".merged(with: string2, indented: 26)
        case .barGraph(let graph):
            return graph.description
        case .lineGraph(let string, let graph, let symbol):
            return "\(symbol ?? " ") \(string.indented(to: 10))".merged(with: graph.description, indented: 14)
        case .discussion(let string):
            return string
        case .empty:
            return ""
        }
    }
}

enum PrintableLabel: ExpressibleByStringLiteral, CustomStringConvertible {
    case custom(String), options, error
    
    // MARK: ExpressibleByStringLiteral
    typealias StringLiteralType = String
    
    init(stringLiteral value: String) {
        switch value.lowercased() {
        case "options":
            self = .options
        case "error":
            self = .error
        default:
            self = .custom(value)
        }
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        switch self {
        case .custom(let string):
            return !string.isEmpty ? "\(string.uppercased()):" : ""
        case .options:
            return "OPTIONS:"
        case .error:
            return "ERROR:"
        }
    }
}

struct PrintableBarGraph: CustomStringConvertible {
    let values: [Int]
    let scale: Int
    
    var isEmpty: Bool {
        return values.reduce(0, +) < 1
    }
    
    init(values: [Int], scale: Int) {
        let scale: Int = max(scale, 1)
        self.values = values.map { value in
            return min(max(value, 0), scale)
        }
        self.scale = scale
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        var lines: [String] = []
        for line in (0..<scale).reversed() {
            lines.append(values.map { value in
                return value > line ? "🟦" : "⬜️"
            }.joined())
        }
        return lines.joined(separator: .newLine)
    }
}

struct PrintableLineGraph: CustomStringConvertible {
    let string: String
    let value: Int
    
    init(string: String = "", value: Int = 0) {
        self.string = string
        self.value = max(value, 0)
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        guard !string.isEmpty else {
            return ""
        }
        return string.indented(value, character: "▫️")
    }
}

extension Array: Printable where Element == PrintableLine {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        return self
    }
}

extension String {
    static let `default`: String = "(default)"
    
    var redacted: String {
        return map { _ in
            return "\(Self.bullet)"
        }.joined()
    }
    
    fileprivate static let newLine: String = "\n"
    fileprivate static let bullet: String = "•"
    
    fileprivate func merged(with string: String?, indented spaces: Int, character: Character = " ") -> String {
        guard let string: String = string, !string.isEmpty else {
            return self
        }
        guard self.count < spaces else {
            return [self, string.indented(spaces)].joined(separator: .newLine)
        }
        return "\(self)\(string.indented(spaces - self.count, character: character))"
    }
    
    fileprivate func joined(with string: String?) -> String {
        return "\(self)\(string?.indented(1) ?? "")"
    }
    
    fileprivate func indented(to length: Int, character: Character = " ") -> String {
        return indented(max(length - count, 0), character: character)
    }
    
    fileprivate func indented(_ spaces: Int, character: Character = " ") -> String {
        return spaces > 0 ? "\((0..<spaces).map { _ in "\(character)" }.joined())\(self)" : self
    }
}
