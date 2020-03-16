import Cocoa
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
            var string: String = ""
            string.append(string: "KEY: \(URLCredentialStorage.shared.key ?? "<null>")")
            string.append(string: "")
            print(string)
        }
    }
    
    struct Language: ParsableCommand {
        @Argument(help: "Set ISO 639 language code.")
        var language: Weather.Language?
        
        @Flag(name: .shortAndLong, help: "List all language codes.")
        var list: Bool
        
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
            var string: String = ""
            string.append(string: "LANGUAGE: \((UserDefaults.standard.language ?? .auto).rawValue)")
            if list {
                string.append(string: "")
                string.append(string: "OPTIONS:")
                string.append(string: "\(Weather.Language.allCases.map { $0.rawValue }.joined(separator: ", "))")
            }
            string.append(string: "")
            print(string)
        }
    }
    
    struct Units: ParsableCommand {
        @Argument(help: "Select measurement units system.")
        var units: Weather.Units?
         
        @Flag(name: .shortAndLong, help: "List all units systems.")
        var list: Bool
        
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
            var string: String = ""
            string.append(string: "UNITS: \((UserDefaults.standard.units ?? .auto).rawValue)")
            if list {
                string.append(string: "")
                string.append(string: "OPTIONS:")
                for units in Weather.Units.allCases {
                    string.append(string: "  \(units.rawValue) \(units.description)")
                }
            }
            string.append(string: "")
            print(string)
        }
    }
    
    struct Location: ParsableCommand {
        @Argument(help: "Set address or latitude/longitude.")
        var location: String?
        
        @Flag(name: .shortAndLong, help: "Use current location: 0.0,0.0")
        var auto: Bool
        
        // MARK: ParsableCommand
        static var configuration: CommandConfiguration = CommandConfiguration(abstract: "Set geographic location.")
        
        func run() throws {
            
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
            Forecast.Request.key = URLCredentialStorage.shared.key
            Forecast.Request.language = UserDefaults.standard.language ?? .auto
            Forecast.Request.units = UserDefaults.standard.units ?? .auto
            
            
            URLSession.shared.forecast(with: Forecast.Request(coordinate: .null)) { forecast, error in
                CFRunLoopStop(runLoop)
                
                guard let forecast: Forecast = forecast else {
                    print(error!)
                    return
                }
                print(forecast.current?.summary ?? "nil")
            }
            CFRunLoopRun()
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
            var string: String = ""
            string.append(string: "ABOUT: \(Weather.Forecast.attribution.description)")
            string.append(string: "")
            string.append(string: "\(Weather.Forecast.attribution.url.absoluteString)")
            string.append(string: "")
            print(string)
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

// Abstract
// Discussion

// String functions
// Forecast arguments

// [ ] ./weather-cli location "Peaks Island, ME" || 0.0,0.0 || [--auto, -a] || [--null, -0]

