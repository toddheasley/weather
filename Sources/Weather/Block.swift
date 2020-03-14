import Foundation

public struct Block {
    public let points: [Point]
    public let summary: String?
    public let icon: Icon?
}

extension Block: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        points = try container.decode([Point].self, forKey: .data)
        summary = try? container.decode(String.self, forKey: .summary)
        icon = try? container.decode(Icon.self, forKey: .icon)
    }
    
    private enum Key: CodingKey {
        case data, summary, icon
    }
}
