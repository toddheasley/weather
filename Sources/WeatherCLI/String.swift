import Foundation

extension String {
    mutating func append(string: String, after line: String = "\n", indent: String = "") {
        let string: String = string.components(separatedBy: "\n").map { string in
            return "\(indent)\(string)"
        }.joined(separator: "\n")
        self = "\(self)\(line)\(string)"
    }
}
