import Foundation
import Combine
import ArgumentParser
import Weather

extension Forecast {
    public static func publisher(request: Request) -> AnyPublisher<Self, Error> {
        return Future<Self, Error> { handler in
            Self.request(request) { forecast, error in
                guard let forecast: Self = forecast else {
                    handler(.failure(error ?? .forecastNotAvailable))
                    return
                }
                handler(.success(forecast))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Forecast.Error: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .forecastNotAvailable:
            return "Forecast not available"
        case .location(let error):
            return "Location not available: \(error.code)"
        case .keyNotFound:
            return "Key not found"
        case .keyNotRecognized:
            return "Key not recognized"
        case .urlEncodingFailed:
            return "URL encoding failed"
        case .networkRequestFailed:
            return "Network request failed"
        case .dataCorrupted:
            return "Data corrupted"
        }
    }
}

extension Forecast.Block: ExpressibleByArgument {
    
    // MARK: ExpressibleByArgument
    public init?(argument: String) {
        guard let block: Self = Self.allCases.filter({ block in
            return block.description == argument
        }).first else {
            return nil
        }
        self = block
    }
}

extension Forecast.Block: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .current:
            return "current"
        case .minutes:
            return "minutes"
        case .hours:
            return "hours"
        case .days:
            return "days"
        case .alerts:
            return "alerts"
        case .flags:
            return "flags"
        }
    }
}
