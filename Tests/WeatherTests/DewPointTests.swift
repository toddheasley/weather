import XCTest
@testable import Weather

final class DewPointTests: XCTestCase {
    func testFeel() {
        XCTAssertEqual(DewPoint(temperature: Measurement(value: 49.9, unit: Units.us.temperature)).feel, .dry)
        XCTAssertEqual(DewPoint(temperature: Measurement(value: 50.0, unit: Units.us.temperature)).feel, .comfortable)
        XCTAssertEqual(DewPoint(temperature: Measurement(value: 63.9, unit: Units.us.temperature)).feel, .comfortable)
        XCTAssertEqual(DewPoint(temperature: Measurement(value: 64.0, unit: Units.us.temperature)).feel, .humid)
    }
}

extension DewPointTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let dewPoints: [DewPoint] = try JSONDecoder(date: .secondsSince1970, units: .us).decode([DewPoint].self, from: DewPointTests_Data)
            XCTAssertEqual(dewPoints.map { $0.feel }, [.humid, .dry, .comfortable])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let DewPointTests_Data: Data = """
[
    72.0,
    37.86,
    63.2
]
""".data(using: .utf8)!
