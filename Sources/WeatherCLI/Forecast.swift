import Foundation
import ArgumentParser
import Weather

extension Forecast: Printable {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = NumberFormatter()
        measurementFormatter.numberFormatter.numberStyle = .none
        var lines: [PrintableLine] = []
        if let current: Point = current {
            if let temperature: Temperature = current.temperature {
                lines.append(.discussion("\(measurementFormatter.string(from: temperature.actual)) (~\(measurementFormatter.string(from: temperature.apparent)))"))
            }
            if let icon: Icon = current.icon,
                let summary: String = current.summary {
                lines.append(.discussion("\(icon.symbol)  \(summary)"))
            }
            lines.append(.empty)
        }
        if let alert: Alert = alerts?.first {
            lines.append(.label("alert", alert.title))
            lines.append(.empty)
            lines.append(.discussion(alert.description))
            lines.append(.empty)
        }
        if let minutes: Weather.Block = minutes {
            lines.append(.label("next", minutes.summary))
            
            // TODO: Add minutely precipitation bar graph
            
            lines.append(.empty)
        }
        if verbose {
            if let hours: Weather.Block = hours {
                lines.append(.label("next 24 hours"))
                
                // TODO: Add hourly temperature line graph
                
                lines.append(.empty)
            }
            if let days: Weather.Block = days {
                lines.append(.label("next 7 days"))
                
                // TODO: Add daily temperature line graph
                
                lines.append(.empty)
            }
        }
        return lines
    }
}

extension Forecast.Error: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .forecastNotAvailable:
            return "Forecast not available"
        case .location(let error):
            switch error?.code {
            case .denied:
                return "Location denied"
            case .network:
                return Self.networkRequestFailed.description
            default:
                return "Location not found"
            }
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

extension Forecast.Error: Printable {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        return [
            .label(.error, description)
        ]
    }
}
