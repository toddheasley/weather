import Foundation
import ArgumentParser
import Weather

struct ForecastOptions: OptionSet {
    let rawValue: Int

    static let verbose = Self(rawValue: 1 << 0)
    static let wind    = Self(rawValue: 1 << 1)

    static let all: Self = [.verbose, .wind]
}

extension Forecast: Printable {

    func print(options: ForecastOptions) {
        Swift.print(printableLines(options: options).map { line in
            return line.description
        }.joined(separator: .newLine))
    }

    func printableLines(options: ForecastOptions) -> [PrintableLine] {
        var lines: [PrintableLine] = []
        lines.append(contentsOf: printableCurrent)

        if options.contains(.wind) {
            lines.append(contentsOf: printableWind)
        }

        lines.append(contentsOf: printableAlert)
        lines.append(contentsOf: printableMinutes)

        if options.contains(.verbose) {
            lines.append(contentsOf: printableHours)
            lines.append(contentsOf: printableDays)
        }

        return lines
    }

    // MARK: Printable
    func printableLines(verbose: Bool) -> [PrintableLine] {
        var forecastOptions: ForecastOptions = []
        if verbose {
            forecastOptions.insert(.verbose)
        }

        return printableLines(options: forecastOptions)
    }
    
    private var printableCurrent: [PrintableLine] {
        guard let temperature: Temperature = current?.temperature,
            let icon: Icon = current?.icon,
            let summary: String = current?.summary else {
            return []
        }
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter(numberStyle: .none)
        measurementFormatter.unitOptions = .providedUnit
        
        var lines: [PrintableLine] = []
        lines.append(.discussion("\(measurementFormatter.string(from: temperature.actual)) (~\(measurementFormatter.string(from: temperature.apparent)))"))
        lines.append(.discussion("\(icon.symbol)  \(summary)"))
        lines.append(.empty)
        return lines
    }

    private var printableWind: [PrintableLine] {
        guard let wind: Wind = current?.wind else { return [] }

        let speedFormatter: MeasurementFormatter = MeasurementFormatter(numberStyle: .none)
        speedFormatter.unitOptions = .providedUnit
        speedFormatter.unitStyle = .medium

        let bearing = wind.bearing.rawValue.uppercased()
        let speed = speedFormatter.numberFormatter.string(for: wind.speed.value) ?? speedFormatter.string(from: wind.speed)
        let gust = speedFormatter.string(from: wind.gust)

        let summary = "\(speed) to \(gust) from the \(bearing) \(wind.bearing.symbol)"

        return [
            .label("wind", summary),
            .empty
        ]
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
        
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter(numberStyle: .none)
        measurementFormatter.unitOptions = .providedUnit
        
        var lines: [PrintableLine] = []
        lines.append(.label("next 24 hours"))
        for point in points {
            let hour: String = dateFormatter.string(from: point.date)
            let fill: Character = (point.icon ?? .clearDay).fill
            if let temperature: Temperature = point.temperature {
                let string: String = measurementFormatter.string(from: temperature.actual)
                let value: Int = Int(min(max(temperature.actual.converted(to: .fahrenheit).value / 100.0, 0.0), 1.0) * 20.0)
                lines.append(.lineGraph(hour, PrintableLineGraph(string: string, value: value), fill))
            } else {
                lines.append(.lineGraph(hour, nil, fill))
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
        
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter(numberStyle: .none)
        measurementFormatter.unitOptions = .providedUnit
        
        var lines: [PrintableLine] = []
        lines.append(.label("next 7 days"))
        for point in points {
            let day: String = dateFormatter.string(from: point.date)
            if let temperatureInterval: TemperatureInterval = point.temperatureInterval {
                let string: String = [
                    measurementFormatter.string(from: temperatureInterval.low.actual),
                    measurementFormatter.string(from: temperatureInterval.high.actual)
                ].joined(separator: " \(String.bullet) ")
                let averageValue: Double = (temperatureInterval.low.actual.converted(to: .fahrenheit).value + temperatureInterval.high.actual.converted(to: .fahrenheit).value) / 2.0
                let value: Int = Int(min(max(averageValue / 100.0, 0.0), 1.0) * 20.0)
                lines.append(.lineGraph(day, PrintableLineGraph(string: string, value: max(value, 0) + 1), point.icon?.symbol))
            } else {
                lines.append(.lineGraph(day, nil, point.icon?.symbol))
            }
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
