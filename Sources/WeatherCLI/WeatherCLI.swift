import Foundation
import ArgumentParser
import Weather


struct WeatherCLI: ParsableCommand {
    
    // MARK: ParsableCommand
    static var configuration: CommandConfiguration = CommandConfiguration(abstract: Bundle.main.executableName)
    
    func run() throws {
        
    }
}
