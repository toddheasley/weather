import XCTest
@testable import Weather

final class UVIndexTests: XCTestCase {
    func testRisk() {
        XCTAssertEqual(UVIndex(value: 2).risk, .low)
        XCTAssertEqual(UVIndex(value: 3).risk, .moderate)
        XCTAssertEqual(UVIndex(value: 5).risk, .moderate)
        XCTAssertEqual(UVIndex(value: 6).risk, .high)
        XCTAssertEqual(UVIndex(value: 7).risk, .high)
        XCTAssertEqual(UVIndex(value: 8).risk, .veryHigh)
        XCTAssertEqual(UVIndex(value: 10).risk, .veryHigh)
        XCTAssertEqual(UVIndex(value: 11).risk, .extreme)
    }
}

extension UVIndexTests {
    
    // MARK: Comparable
    func testEqual() {
        XCTAssertNotEqual(UVIndex(value: 3), UVIndex(value: 2))
        XCTAssertNotEqual(UVIndex(value: 8), UVIndex(value: 11))
        XCTAssertEqual(UVIndex(value: 2), UVIndex(value: 2))
        XCTAssertEqual(UVIndex(value: 8), UVIndex(value: 8))
    }
    
    func testLessThan() {
        XCTAssertFalse(UVIndex(value: 5) < UVIndex(value: 4))
        XCTAssertFalse(UVIndex(value: 5) < UVIndex(value: 5))
        XCTAssertTrue(UVIndex(value: 4) < UVIndex(value: 5))
    }
}

extension UVIndexTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let uvIndex: UVIndex = try JSONDecoder(date: .secondsSince1970).decode(UVIndex.self, from: UVIndexTests_Data)
            XCTAssertEqual(uvIndex.value, 3)
            XCTAssertEqual(uvIndex.date, Date(timeIntervalSince1970: 1522701260.0))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let UVIndexTests_Data: Data = """
{
    "uvIndex": 3,
    "uvIndexTime": 1522701260
}
""".data(using: .utf8)!
