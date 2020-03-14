import Foundation

public struct Source {
    public let name: String
    public let stations: [String]?
}

extension Source: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        name = try container.decode(String.self)
        stations = nil
    }
}
