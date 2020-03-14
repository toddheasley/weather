import XCTest
@testable import Weather

final class IconTests: XCTestCase {
    func testAllCases() {
        XCTAssertEqual(Icon.allCases.count, 10)
    }
    
    func testIsPrecipitation() {
        XCTAssertFalse(Icon.clearDay.isPrecipitation)
        XCTAssertFalse(Icon.clearNight.isPrecipitation)
        XCTAssertFalse(Icon.cloudy.isPrecipitation)
        XCTAssertFalse(Icon.fog.isPrecipitation)
        XCTAssertFalse(Icon.partlyCloudyDay.isPrecipitation)
        XCTAssertFalse(Icon.partlyCloudyNight.isPrecipitation)
        XCTAssertTrue(Icon.rain.isPrecipitation)
        XCTAssertTrue(Icon.sleet.isPrecipitation)
        XCTAssertTrue(Icon.snow.isPrecipitation)
        XCTAssertFalse(Icon.wind.isPrecipitation)
    }
}
