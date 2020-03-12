import Foundation

public enum Bearing: String, CaseIterable {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
    
    public var angle: Double {
        return Double(Bearing.allCases.firstIndex(of: self)!) * 22.5
    }
    
    public init?(angle: Double?) {
        guard let angle: Double = angle, angle >= 0.0, angle < 360.0 else {
            return nil
        }
        self = Bearing.allCases[Int(angle / 22.5 + 0.5) % Bearing.allCases.count]
    }
}

extension Bearing: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let angle: Double = try container.decode(Double.self)
        guard let bearing: Bearing = Bearing(angle: angle) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        self = bearing
    }
}
