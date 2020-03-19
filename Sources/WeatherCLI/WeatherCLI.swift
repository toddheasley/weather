import Cocoa
import CoreLocation
import ArgumentParser
import Weather

struct WeatherCLI: ParsableCommand {
    struct Key: ParsableCommand {
        @Argument(help: "Set Dark Sky API key.")
        var key: String?
        
        @Flag(name: [.customShort("r"), .long], help: "Delete key from Keychain.")
        var remove: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set API secret key.")
        
        func run() throws {
            if remove {
                URLCredentialStorage.shared.key = nil
            } else if let key: String = key, !key.isEmpty {
                URLCredentialStorage.shared.key = key
            }
            print("KEY")
        }
    }
    
    struct Language: ParsableCommand {
        @Argument(help: "Set ISO 639 language code.")
        var language: Weather.Language?
        
        @Flag(name: .shortAndLong, help: "Reset to default language: \(Weather.Language.auto.rawValue)")
        var auto: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set forecast language.")
        
        func run() throws {
            if auto {
                UserDefaults.standard.language = nil
            } else if let language: Weather.Language = language {
                UserDefaults.standard.language = language
            }
            print("LANGUAGE")
        }
    }
    
    struct Units: ParsableCommand {
        @Argument(help: "Select measurement units system.")
        var units: Weather.Units?
        
        @Flag(name: .shortAndLong, help: "Reset to default units: \(Weather.Language.auto.rawValue)")
        var auto: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set measurement units.")
        
        func run() throws {
            if auto {
                UserDefaults.standard.units = nil
            } else if let units: Weather.Units = units {
                UserDefaults.standard.units = units
            }
            print("UNITS")
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
                    guard let location: CLGeocoder.Location = location else {
                        print(error)
                        return
                    }
                    UserDefaults.standard.coordinate = location.coordinate
                    print("LOCATION")
                }
                return
            }
            CLGeocoder.geocode(coordinate: UserDefaults.standard.coordinate) { location, error in
                CFRunLoopStop(runLoop)
                guard let location: CLGeocoder.Location = location else {
                    print(error)
                    return
                }
                print("LOCATION")
            }
        }
    }
    
    struct Forecast: ParsableCommand {
        @Option(name: .shortAndLong, help: "Set forecast date in Unix seconds.")
        var date: Date?
        
        @Option(name: .shortAndLong, help: "Customize forecast.")
        var blocks: Weather.Forecast.Block?
        
        @Flag(name: .shortAndLong, help: "Extend hourly forecast to 7 days.")
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
                Forecast.request(Forecast.Request(coordinate: location.coordinate)) { forecast, error in
                    CFRunLoopStop(runLoop)
                    guard let forecast: Forecast = forecast else {
                        print(error ?? Forecast.Error.networkRequestFailed)
                        return
                    }
                    print("FORECAST")
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
            print("ABOUT")
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
