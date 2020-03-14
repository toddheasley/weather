import XCTest
@testable import Weather

final class TemperatureIntervalTests: XCTestCase {
    
}

extension TemperatureIntervalTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let temperatureInterval: TemperatureInterval = try JSONDecoder(date: .secondsSince1970, units: .us).decode(TemperatureInterval.self, from: TemperatureIntervalTests_Data)
            XCTAssertEqual(temperatureInterval.low.actual, Measurement(value: 41.28, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.low.apparent, Measurement(value: 35.74, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.low.date?.actual, Date(timeIntervalSince1970: 1510056000.0))
            XCTAssertEqual(temperatureInterval.low.date?.apparent, Date(timeIntervalSince1970: 1510056000.0))
            XCTAssertEqual(temperatureInterval.high.actual, Measurement(value: 66.35, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.high.apparent, Measurement(value: 66.53, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.high.date?.actual, Date(timeIntervalSince1970: 1509994800.0))
            XCTAssertEqual(temperatureInterval.high.date?.apparent, Date(timeIntervalSince1970: 1509994800.0))
            XCTAssertEqual(temperatureInterval.min.actual, Measurement(value: 52.08, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.min.apparent, Measurement(value: 52.08, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.min.date?.actual, Date(timeIntervalSince1970: 1510027200.0))
            XCTAssertEqual(temperatureInterval.min.date?.apparent, Date(timeIntervalSince1970: 1510027200.0))
            XCTAssertEqual(temperatureInterval.max.actual, Measurement(value: 66.35, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.max.apparent, Measurement(value: 66.53, unit: Units.us.temperature))
            XCTAssertEqual(temperatureInterval.max.date?.actual, Date(timeIntervalSince1970: 1509994800.0))
            XCTAssertEqual(temperatureInterval.max.date?.apparent, Date(timeIntervalSince1970: 1509994800.0))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let TemperatureIntervalTests_Data: Data = """
{
    "temperatureHigh": 66.35,
    "temperatureHighTime": 1509994800,
    "temperatureLow": 41.28,
    "temperatureLowTime": 1510056000,
    "apparentTemperatureHigh": 66.53,
    "apparentTemperatureHighTime": 1509994800,
    "apparentTemperatureLow": 35.74,
    "apparentTemperatureLowTime": 1510056000,
    "temperatureMin": 52.08,
    "temperatureMinTime": 1510027200,
    "temperatureMax": 66.35,
    "temperatureMaxTime": 1509994800,
    "apparentTemperatureMin": 52.08,
    "apparentTemperatureMinTime": 1510027200,
    "apparentTemperatureMax": 66.53,
    "apparentTemperatureMaxTime": 1509994800
}
""".data(using: .utf8)!
