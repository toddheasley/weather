import Foundation

public struct UVIndex {
    public enum Color: String, CaseIterable {
        case green, yellow, orange, red, violet
    }
    
    public enum Risk: String, CaseIterable, CustomStringConvertible {
        case low, moderate, high, veryHigh = "very high", extreme
        
        // MARK: CustomStringConvertible
        public var description: String {
            return rawValue
        }
    }
    
    public let value: Int
    public let date: Date?
    
    public var color: Color {
        switch risk {
        case .low:
            return .green
        case .moderate:
            return .yellow
        case .high:
            return .orange
        case .veryHigh:
            return .red
        case .extreme:
            return .violet
        }
    }
    
    public var risk: Risk {
        if value < 3 {
            return .low
        } else if value < 6 {
            return .moderate
        } else if value < 8 {
            return .high
        } else if value < 11 {
            return .veryHigh
        } else {
            return .extreme
        }
    }
    
    public init(value: Int, date: Date? = nil) {
        self.value = max(value, 0)
        self.date = date
    }
}

extension UVIndex: ExpressibleByIntegerLiteral  {
    
    // MARK: ExpressibleByIntegerLiteral
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value: value)
    }
}

extension UVIndex: Comparable {
    
    // MARK: Comparable
    public static func ==(x: UVIndex, y: UVIndex) -> Bool {
        return Int(x.value) == Int(y.value)
    }
    
    public static func <(x: UVIndex, y: UVIndex) -> Bool {
        return Int(x.value) < Int(y.value)
    }
}

extension UVIndex: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        self.init(value: try container.decode(Int.self, forKey: .uvIndex), date: try? container.decode(Date.self, forKey: .uvIndexTime))

    }
    
    private enum Key: CodingKey {
        case uvIndex, uvIndexTime
    }
}
