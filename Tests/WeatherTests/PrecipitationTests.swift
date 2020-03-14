import XCTest
@testable import Weather

final class PrecipitationTests: XCTestCase {
    func testPhase() {
        XCTAssertEqual(Precipitation.Phase.allCases.count, 4)
    }
    
    func testSeverity() {
        XCTAssertEqual(Precipitation(phase: .rain, accumulation: nil, intensity: Measurement(value: 0.31, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .heavy)
        XCTAssertEqual(Precipitation(phase: .sleet, accumulation: nil, intensity: Measurement(value: 0.3, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .medium)
        XCTAssertEqual(Precipitation(phase: .snow, accumulation: nil, intensity: Measurement(value: 0.11, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .medium)
        XCTAssertEqual(Precipitation(phase: .rain, accumulation: nil, intensity: Measurement(value: 0.1, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .light)
        XCTAssertEqual(Precipitation(phase: .sleet, accumulation: nil, intensity: Measurement(value: 0.021, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .light)
        XCTAssertEqual(Precipitation(phase: .snow, accumulation: nil, intensity: Measurement(value: 0.02, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .trace)
        XCTAssertEqual(Precipitation(phase: .rain, accumulation: nil, intensity: Measurement(value: 0.3, unit: Units.us.accumulation), max: nil, probability: 0.25).severity, .none)
        XCTAssertEqual(Precipitation(phase: .none, accumulation: nil, intensity: Measurement(value: 0.3, unit: Units.us.accumulation), max: nil, probability: 0.26).severity, .none)
        XCTAssertEqual(Precipitation(phase: .snow, accumulation: nil, intensity: nil, max: nil, probability: 0.26).severity, .none)
        XCTAssertEqual(Precipitation.Severity.allCases.count, 5)
    }
}

extension PrecipitationTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let precipitation: Precipitation = try JSONDecoder(date: .secondsSince1970, units: .us).decode(Precipitation.self, from: PrecipitationTests_Data)
            XCTAssertEqual(precipitation.phase, .rain)
            XCTAssertEqual(precipitation.accumulation, Measurement(value: 0.4, unit: Units.us.accumulation))
            XCTAssertEqual(precipitation.intensity, Measurement(value: 0.0125, unit: Units.us.accumulation))
            XCTAssertEqual(precipitation.max?.intensity, Measurement(value: 0.0531, unit: Units.us.accumulation))
            XCTAssertEqual(precipitation.max?.date, Date(timeIntervalSince1970: 1492056000.0))
            XCTAssertEqual(precipitation.probability, 0.73)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let PrecipitationTests_Data: Data = """
{
    "precipType": "rain",
    "precipAccumulation": 0.4,
    "precipIntensity": 0.0125,
    "precipIntensityMax": 0.0531,
    "precipIntensityMaxTime": 1492056000,
    "precipProbability": 0.73
}
""".data(using: .utf8)!
