import XCTest
@testable import Weather

final class WindTests: XCTestCase {
    
}

extension WindTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let wind: Wind = try JSONDecoder(date: .secondsSince1970, units: .us).decode(Wind.self, from: WindTests_Data)
            XCTAssertEqual(wind.bearing, .w)
            XCTAssertEqual(wind.speed, Measurement(value: 6.46, unit: Units.us.speed))
            XCTAssertEqual(wind.gust, Measurement(value: 14, unit: Units.us.speed))
            XCTAssertEqual(wind.date, Date(timeIntervalSince1970: 1522701260.0))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let WindTests_Data: Data = """
{
    "windBearing": 281,
    "windSpeed": 6.46,
    "windGust": 14,
    "windGustTime": 1522701260
}

""".data(using: .utf8)!
