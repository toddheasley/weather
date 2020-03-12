import XCTest
@testable import Weather

final class UnitsTests: XCTestCase {
    func testAuto() {
        XCTAssertEqual(Units.auto, .us)
    }
    
    // MARK: CaseIterable
    func testAllCases() {
        XCTAssertEqual(Units.allCases.count, 4)
    }
}
