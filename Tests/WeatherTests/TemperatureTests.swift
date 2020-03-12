import XCTest
@testable import Weather

final class TemperatureTests: XCTestCase {
    
}

extension TemperatureTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let temperature: Temperature = try JSONDecoder(date: .secondsSince1970, units: .us).decode(Temperature.self, from: TemperatureTests_Data)
            XCTAssertEqual(temperature.actual, Measurement(value: 49.52, unit: Units.us.temperature))
            XCTAssertEqual(temperature.apparent, Measurement(value: 46.87, unit: Units.us.temperature))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let TemperatureTests_Data: Data = """
{
    "temperature": 49.52,
    "apparentTemperature": 46.87
}
""".data(using: .utf8)!
