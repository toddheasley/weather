import Cocoa
import CoreLocation
import ArgumentParser
import Weather

struct WeatherCLI: ParsableCommand {
    struct Key: ParsableCommand {
        @Argument(help: "Set Dark Sky API key.")
        var key: String?
        
        @Flag(name: .shortAndLong, help: "Delete key from Keychain.")
        var remove: Bool
        
        @Flag(name: .shortAndLong, help: "Show key in plain text.")
        var show: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set API secret key.")
        
        func run() throws {
            if remove {
                URLCredentialStorage.shared.key = nil
            } else if let key: String = key, !key.isEmpty {
                URLCredentialStorage.shared.key = key
            }
            [
                .label("key", (show ? URLCredentialStorage.shared.key : URLCredentialStorage.shared.key?.redacted) ?? Weather.Forecast.Error.keyNotFound.description)
            ].print()
        }
    }
    
    struct Language: ParsableCommand {
        @Argument(help: "Set ISO 639 language code.")
        var language: Weather.Language?
        
        @Flag(name: .shortAndLong, help: "Reset to default language: \(Weather.Language.auto.rawValue)")
        var auto: Bool
        
        @Flag(name: .shortAndLong, help: "List available languages.")
        var list: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set forecast language.")
        
        func run() throws {
            if auto {
                UserDefaults.standard.language = nil
            } else if let language: Weather.Language = language {
                UserDefaults.standard.language = language
            }
            (UserDefaults.standard.language ?? .auto).print(verbose: list)
        }
    }
    
    struct Units: ParsableCommand {
        @Argument(help: "Select measurement units system.")
        var units: Weather.Units?
        
        @Flag(name: .shortAndLong, help: "Reset to default units: \(Weather.Language.auto.rawValue)")
        var auto: Bool
        
        @Flag(name: .shortAndLong, help: "List available units.")
        var list: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set measurement units.")
        
        func run() throws {
            if auto {
                UserDefaults.standard.units = nil
            } else if let units: Weather.Units = units {
                UserDefaults.standard.units = units
            }
            (UserDefaults.standard.units ?? .auto).print(verbose: list)
        }
    }
    
    struct Location: ParsableCommand {
        @Argument(help: "Set fixed location by address.")
        var address: String?
        
        @Option(name: .shortAndLong, help: "Set fixed comma-separated latitude and longitude.")
        var coordinate: CLLocationCoordinate2D?
        
        @Flag(name: .shortAndLong, help: "Use current location.")
        var auto: Bool
        
        @Flag(name: [.customShort("0"), .long], help: .hidden)
        var null: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set geographic location.")
        
        func run() throws {
            let runLoop: CFRunLoop = CFRunLoopGetCurrent()
            defer {
                CFRunLoopRun()
            }
            if auto {
                UserDefaults.standard.coordinate = nil
            } else if let coordinate: CLLocationCoordinate2D = coordinate {
                UserDefaults.standard.coordinate = coordinate
            } else if let address: String = address, !address.isEmpty {
                CLGeocoder.geocode(address: address) { location, error in
                    CFRunLoopStop(runLoop)
                    if let location: CLGeocoder.Location = location {
                        UserDefaults.standard.coordinate = location.coordinate
                        location.print(verbose: true)
                    } else {
                        Weather.Forecast.Error.location(error).print()
                    }
                }
                return
            }
            CLGeocoder.geocode(coordinate: UserDefaults.standard.coordinate) { location, error in
                CFRunLoopStop(runLoop)
                if let location: CLGeocoder.Location = location {
                    location.print(verbose: true)
                } else {
                    Weather.Forecast.Error.location(error).print()
                }
            }
        }
    }
    
    struct Forecast: ParsableCommand {
        @Option(name: .shortAndLong, help: "Set forecast date in Unix seconds.")
        var date: Date?
        
        @Flag(name: .shortAndLong, help: "Show extended forecast.")
        var extend: Bool

        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Show weather forecast.")
        
        func run() throws {
            let runLoop: CFRunLoop = CFRunLoopGetCurrent()
            defer {
                CFRunLoopRun()
            }
            CLGeocoder.geocode(coordinate: UserDefaults.standard.coordinate) { location, error in
                guard let location: CLGeocoder.Location = location else {
                    CFRunLoopStop(runLoop)
                    print(Forecast.Error.location(error ?? CLError(CLError.Code.geocodeFoundNoResult)))
                    return
                }
                Forecast.Request.key = URLCredentialStorage.shared.key
                Forecast.Request.language = UserDefaults.standard.language ?? .auto
                Forecast.Request.units = UserDefaults.standard.units ?? .auto
                Forecast.request(Forecast.Request(coordinate: location.coordinate, date: self.date)) { forecast, error in
                    CFRunLoopStop(runLoop)
                    if let forecast: Forecast = forecast {
                        if let date: Date = self.date {
                            let dateFormatter: DateFormatter = DateFormatter(timeZone: forecast.timeZone)
                            dateFormatter.dateStyle = .full
                            dateFormatter.timeStyle = .short
                            [
                                .label("time machine", "\(dateFormatter.string(from: date))")
                            ].print()
                        }
                        [
                            .discussion(location.description),
                            .empty
                        ].print()
                        forecast.print(verbose: self.extend)
                    } else {
                        (error ?? Forecast.Error.networkRequestFailed).print()
                    }
                }
            }
        }
        
        private typealias Forecast = Weather.Forecast
    }
    
    struct About: ParsableCommand {
        @Flag(name: .shortAndLong, help: "Open in browser: \(Weather.Forecast.attribution.url.absoluteString)")
        var open: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "\(Weather.Forecast.attribution.description).")
        
        func run() throws {
            if open {
                NSWorkspace.shared.open(Weather.Forecast.attribution.url)
            }
            [
                .label("about", "(c) toddheasley"),
                .empty,
                .discussion(Weather.Forecast.attribution.description),
                .discussion(Weather.Forecast.attribution.url.absoluteString),
                .empty
            ].print()
        }
    }
    
    // MARK: ParsableCommand
    static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Abstract.",
        discussion: "Discussion.",
        subcommands: [
            Key.self,
            Language.self,
            Units.self,
            Location.self,
            Forecast.self,
            About.self
        ],
        defaultSubcommand: Forecast.self
    )
}
