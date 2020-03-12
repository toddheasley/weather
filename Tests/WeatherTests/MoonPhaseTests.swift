import XCTest
@testable import Weather

final class MoonPhaseTests: XCTestCase {
    func testPercentage() {
        XCTAssertEqual(MoonPhase(value: 0.0).percentage, 0.0)
        XCTAssertEqual(MoonPhase(value: 0.01).percentage, 0.02)
        XCTAssertEqual(MoonPhase(value: 0.17).percentage, 0.34)
        XCTAssertEqual(MoonPhase(value: 0.5).percentage, 1.0)
        XCTAssertEqual(MoonPhase(value: 0.71).percentage, 0.58)
        XCTAssertEqual(MoonPhase(value: 0.99).percentage, 0.02)
        XCTAssertEqual(MoonPhase(value: 1.0).percentage, 0.02)
    }
    
    func testDirection() {
        XCTAssertEqual(MoonPhase(value: 0.0).direction, .waxing)
        XCTAssertEqual(MoonPhase(value: 0.49).direction, .waxing)
        XCTAssertEqual(MoonPhase(value: 0.5).direction, .waning)
        XCTAssertEqual(MoonPhase(value: 1.0).direction, .waning)
    }
    
    func testName() {
        XCTAssertEqual(MoonPhase(value: 0.0).name, .new)
        XCTAssertEqual(MoonPhase(value: 0.022).name, .new)
        XCTAssertEqual(MoonPhase(value: 0.023).name, .crescent(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.222).name, .crescent(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.223).name, .quarter(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.277).name, .quarter(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.278).name, .gibbous(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.477).name, .gibbous(.waxing))
        XCTAssertEqual(MoonPhase(value: 0.478).name, .full)
        XCTAssertEqual(MoonPhase(value: 0.522).name, .full)
        XCTAssertEqual(MoonPhase(value: 0.523).name, .gibbous(.waning))
        XCTAssertEqual(MoonPhase(value: 0.722).name, .gibbous(.waning))
        XCTAssertEqual(MoonPhase(value: 0.723).name, .quarter(.waning))
        XCTAssertEqual(MoonPhase(value: 0.777).name, .quarter(.waning))
        XCTAssertEqual(MoonPhase(value: 0.778).name, .crescent(.waning))
        XCTAssertEqual(MoonPhase(value: 0.977).name, .crescent(.waning))
        XCTAssertEqual(MoonPhase(value: 0.978).name, .new)
        XCTAssertEqual(MoonPhase(value: 1.0).name, .new)
    }
    
    func testValueInit() {
        XCTAssertEqual(MoonPhase(value: -0.1).value, 0.0)
        XCTAssertEqual(MoonPhase(value: 0.0).value, 0.0)
        XCTAssertEqual(MoonPhase(value: 0.17).value, 0.17)
        XCTAssertEqual(MoonPhase(value: 0.5).value, 0.5)
        XCTAssertEqual(MoonPhase(value: 0.71).value, 0.71)
        XCTAssertEqual(MoonPhase(value: 1.0).value, 0.99)
        XCTAssertEqual(MoonPhase(value: 1.1).value, 0.99)
    }
}

extension MoonPhaseTests {

    // MARK: Equatable
    func testEqual() {
        XCTAssertEqual(MoonPhase(value: 0.0), MoonPhase(value: 0.0))
        XCTAssertNotEqual(MoonPhase(value: 0.59), MoonPhase(value: 0.58))
        XCTAssertEqual(MoonPhase(value: 0.59), MoonPhase(value: 0.59))
        XCTAssertNotEqual(MoonPhase(value: 0.59), MoonPhase(value: 0.6))
        XCTAssertEqual(MoonPhase(value: 1.0), MoonPhase(value: 1.0))
    }
}

extension MoonPhaseTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let moonPhases: [MoonPhase] = try JSONDecoder().decode([MoonPhase].self, from: MoonPhaseTests_Data)
            XCTAssertEqual(moonPhases, [MoonPhase(value: 0.04), MoonPhase(value: 0.76), MoonPhase(value: 0.5)])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let MoonPhaseTests_Data: Data = """
[
    0.04,
    0.76,
    0.5
]
""".data(using: .utf8)!
