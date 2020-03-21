import Foundation
import ArgumentParser
import Weather

extension Forecast: Printable {
    
    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        var lines: [PrintableLine] = []
        lines.append(contentsOf: printableCurrent)
        lines.append(contentsOf: printableAlert)
        lines.append(contentsOf: printableMinutes)
        if !verbose {
            lines.append(contentsOf: printableHours)
            lines.append(contentsOf: printableDays)
        }
        return lines
    }
    
    private var printableCurrent: [PrintableLine] {
        guard let temperature: Temperature = current?.temperature,
            let icon: Icon = current?.icon,
            let summary: String = current?.summary else {
            return []
        }
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = NumberFormatter()
        measurementFormatter.numberFormatter.numberStyle = .none
        
        var lines: [PrintableLine] = []
        lines.append(.discussion("\(measurementFormatter.string(from: temperature.actual)) (~\(measurementFormatter.string(from: temperature.apparent)))"))
        lines.append(.discussion("\(icon.symbol)  \(summary)"))
        lines.append(.empty)
        return lines
    }
    
    private var printableAlert: [PrintableLine] {
        guard let alert: Alert = alerts?.first else {
            return []
        }
        var lines: [PrintableLine] = []
        lines.append(.label("alert", alert.title))
        lines.append(.empty)
        lines.append(.discussion(alert.description))
        lines.append(.empty)
        return lines
    }
    
    private var printableMinutes: [PrintableLine] {
        guard let minutes: Weather.Block = minutes,
            let summary: String = minutes.summary, !summary.isEmpty else {
            return []
        }
        var values: [Int] = []
        for (index, point) in minutes.points.enumerated() {
            guard values.count < 20  else {
                break
            }
            guard index % 3 == 0 else {
                continue
            }
            values.append(point.precipitation?.severity.value ?? 0)
        }
        let barGraph: PrintableBarGraph = PrintableBarGraph(values: values, scale: Precipitation.Severity.scale)
        
        var lines: [PrintableLine] = []
        lines.append(.label("next", minutes.summary))
        if !barGraph.isEmpty {
            lines.append(.barGraph(barGraph))
        }
        lines.append(.empty)
        return lines
    }
    
    private var printableHours: [PrintableLine] {
        let points: [Point] = Array(hours?.points.prefix(24) ?? [])
        guard points.count == 24 else {
            return []
        }
        let dateFormatter: DateFormatter = DateFormatter(timeZone: timeZone)
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = NumberFormatter()
        measurementFormatter.numberFormatter.numberStyle = .none
        
        var lines: [PrintableLine] = []
        lines.append(.label("next 24 hours"))
        for point in points {
            let date: String = dateFormatter.string(from: point.date)
            let fill: String = (point.icon ?? .clearDay).fill
            if let temperature: Temperature = point.temperature {
                let string: String = measurementFormatter.string(from: temperature.actual)
                let value: Int = 4
                lines.append(.lineGraph(date, PrintableLineGraph(string: string, value: value), fill))
            } else {
                lines.append(.lineGraph(date, PrintableLineGraph(), fill))
            }
        }
        lines.append(.empty)
        return lines
    }
    
    private var printableDays: [PrintableLine] {
        let points: [Point] = Array(days?.points.prefix(7) ?? [])
        guard points.count == 7 else {
            return []
        }
        let dateFormatter: DateFormatter = DateFormatter(timeZone: timeZone)
        dateFormatter.dateFormat = "EEEE"
        
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = NumberFormatter()
        measurementFormatter.numberFormatter.numberStyle = .none
        
        var lines: [PrintableLine] = []
        lines.append(.label("next 7 days"))
        for point in points {
            lines.append(.lineGraph(dateFormatter.string(from: point.date), PrintableLineGraph(), point.icon?.symbol))
        }
        lines.append(.empty)
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
