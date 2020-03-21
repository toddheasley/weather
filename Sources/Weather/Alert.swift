import Foundation

public struct Alert: CustomStringConvertible {
    public enum Severity: String, CaseIterable, Decodable {
        case advisory, watch, warning
    }
    
    public let severity: Severity
    public let date: DateInterval
    public let regions: [String]
    public let title: String
    public let url: URL
    
    // MARK: CustomStringConvertible
    public let description: String
}

extension Alert: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        severity = try container.decode(Severity.self, forKey: .severity)
        date = DateInterval(start: try container.decode(Date.self, forKey: .time), end: try container.decode(Date.self, forKey: .expires))
        regions = try container.decode([String].self, forKey: .regions)
        title = try container.decode(String.self, forKey: .title)
        description = (try container.decode(String.self, forKey: .description)).trimmingCharacters(in: .whitespacesAndNewlines)
        url = try container.decode(URL.self, forKey: .uri)
    }
    
    private enum Key: CodingKey {
        case severity, time, expires, regions, title, description, uri
    }
}
