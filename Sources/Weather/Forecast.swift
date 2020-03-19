import Foundation
import CoreLocation

public struct Forecast {
    public enum Error: Swift.Error {
        case forecastNotAvailable, location(CLError?), keyNotFound, keyNotRecognized, urlEncodingFailed, networkRequestFailed, dataCorrupted
    }
    
    public struct Request {
        public static var key: String?
        public static var language: Language = .auto
        public static var units: Units = .auto
        
        public let coordinate: CLLocationCoordinate2D
        public let date: Date?
        public let blocks: [Block]
        
        public func url() throws -> URL {
            guard let key: String = Forecast.Request.key, !key.isEmpty else {
                throw Forecast.Error.keyNotFound
            }
            guard var components: URLComponents = URLComponents(string: "https://api.darksky.net/forecast/") else {
                throw Forecast.Error.urlEncodingFailed
            }
            components.path += "\(key)/\(coordinate.latitude),\(coordinate.longitude)"
            if let date: Date = date {
                components.path += ",\(Int(date.timeIntervalSince1970))"
            }
            components.queryItems = [
                URLQueryItem(name: "units", value: "\(Forecast.Request.units.rawValue)"),
                URLQueryItem(name: "lang", value: "\(Forecast.Request.language.rawValue)"),
            ]
            let exclude: String = Block.excluded(from: blocks).map { block in
                return block.value
            }.joined(separator: ",")
            if !exclude.isEmpty {
                components.queryItems?.append(URLQueryItem(name: "exclude", value: exclude))
            }
            if blocks.contains(where: { block in
                return block.extended
            }) {
                components.queryItems?.append(URLQueryItem(name: "extend", value: Block.hours(extended: true).value))
            }
            guard let url: URL = components.url else {
                throw Forecast.Error.urlEncodingFailed
            }
            return url
        }
        
        public init(coordinate: CLLocationCoordinate2D, date: Date? = nil, blocks: [Block] = Block.allCases) {
            self.coordinate = coordinate
            self.date = date
            self.blocks = blocks
        }
    }
    
    public enum Block: CaseIterable, Equatable {
        case current, minutes, hours(extended: Bool), days, alerts, flags
        
        public static func excluded(from blocks: [Block]) -> [Block] {
            return Block.allCases.filter { block in
                return !blocks.contains(block)
            }
        }
        
        fileprivate var extended: Bool {
            switch self {
            case .hours(let extended):
                return extended
            default:
                return false
            }
        }
        
        fileprivate var value: String {
            switch self {
            case .current:
                return "currently"
            case .minutes:
                return "minutely"
            case .hours:
                return "hourly"
            case .days:
                return "daily"
            case .alerts:
                return "alerts"
            case .flags:
                return "flags"
            }
        }
        
        // MARK: CaseIterable
        public static let allCases: [Block] = [.current, .minutes, .hours(extended: false), .days, .alerts, .flags]
        
        // MARK: Equatable
        public static func ==(x: Self, y: Self) -> Bool {
            return x.value == y.value
        }
    }
    
    public static let attribution: (url: URL, description: String) = (URL(string: "https://darksky.net/poweredby")!, "Powered by Dark Sky")
    
    public static func request(_ request: Request, completion: @escaping (Self?, Error?) -> Void) {
        URLSession.shared.forecast(with: request, completion: completion)
    }
    
    public let units: Units
    public let coordinate: CLLocationCoordinate2D
    public let timeZone: TimeZone
    public let current: Point?
    public let minutes: Weather.Block?
    public let hours: Weather.Block?
    public let days: Weather.Block?
    public let alerts: [Alert]?
    public let flags: Flags?
}

extension Forecast: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        coordinate = try CLLocationCoordinate2D(from: decoder)
        guard let identifier: String = try? container.decode(String.self, forKey: .timezone),
            let timeZone: TimeZone = TimeZone(identifier: identifier) else {
            throw DecodingError.dataCorruptedError(forKey: .timezone, in: container, debugDescription: "")
        }
        self.timeZone = timeZone
        current = try? container.decode(Point.self, forKey: .currently)
        minutes = try? container.decode(Weather.Block.self, forKey: .minutely)
        hours = try? container.decode(Weather.Block.self, forKey: .hourly)
        days = try? container.decode(Weather.Block.self, forKey: .daily)
        alerts = try? container.decode([Alert].self, forKey: .alerts)
        flags = try? container.decode(Flags.self, forKey: .flags)
        units = try flags?.units ?? decoder.units()
    }
    
    private enum Key: CodingKey {
        case timezone, currently, minutely, hourly, daily, alerts, flags
    }
}
