import Foundation

public struct MoonPhase {
    public enum Direction: String {
        case waxing, waning
    }
    
    public enum Name: CustomStringConvertible, Equatable {
        case new, crescent(Direction), quarter(Direction), gibbous(Direction), full
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .new:
                return "new"
            case .crescent(let direction):
                return "\(direction.rawValue) crescent"
            case .quarter(let direction):
                return "\(direction == .waxing ? "first" : "third") quarter"
            case .gibbous(let direction):
                return "\(direction.rawValue) gibbous"
            case .full:
                return "full"
            }
        }
    }
    
    public let value: Double
    
    public var percentage: Double {
        return round((value > 0.5 ? 1.0 - value : value) * 200.0) / 100.0
    }
    
    public var direction: Direction {
        return value < 0.5 ? .waxing : .waning
    }
    
    public var name: Name {
        if percentage < 0.05 {
            return .new
        } else if percentage < 0.45 {
            return .crescent(direction)
        } else if percentage < 0.56 {
            return .quarter(direction)
        } else if percentage < 0.96 {
            return .gibbous(direction)
        } else {
            return .full
        }
    }
    
    public init(value: Double) {
        self.value = min(max(value, 0.0), 0.99)
    }
}

extension MoonPhase: ExpressibleByFloatLiteral {
    
    // MARK: ExpressibleByFloatLiteral
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        self.init(value: value)
    }
}

extension MoonPhase: Equatable {
    
    // MARK: Equatable
    public static func ==(x: MoonPhase, y: MoonPhase) -> Bool {
        return x.value == y.value
    }
}

extension MoonPhase: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self.init(value: try container.decode(Double.self))
    }
}
