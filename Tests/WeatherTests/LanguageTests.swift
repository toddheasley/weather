import XCTest
@testable import Weather

final class LanguageTests: XCTestCase {
    func testAuto() {
        XCTAssertEqual(Language.auto, Locale.current.language ?? .en)
    }
    
    // MARK: CaseIterable
    func testAllCases() {
        XCTAssertEqual(Language.allCases.count, 53)
    }
}
