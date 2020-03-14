import XCTest
@testable import Weather

final class AlertTests: XCTestCase {
    
}

extension AlertTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let alert: Alert = try JSONDecoder(date: .secondsSince1970).decode(Alert.self, from: AlertTests_Data)
            XCTAssertEqual(alert.severity, .advisory)
            XCTAssertEqual(alert.date, DateInterval(start: Date(timeIntervalSince1970: 1522701260.0), duration: 43200.0))
            XCTAssertEqual(alert.regions, ["Cape Elizabeth"])
            XCTAssertEqual(alert.title, "Wind Advisory")
            XCTAssertEqual(alert.description, "...WIND ADVISORY REMAINS IN EFFECT FROM 4 PM THIS AFTERNOON TO 4 AM...")
            XCTAssertEqual(alert.url.absoluteString, "https://alerts.weather.gov/")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let AlertTests_Data: Data = """
{
    "title": "Wind Advisory",
    "regions": [
        "Cape Elizabeth"
    ],
    "severity": "advisory",
    "time": 1522701260,
    "expires": 1522744460,
    "description": "...WIND ADVISORY REMAINS IN EFFECT FROM 4 PM THIS AFTERNOON TO 4 AM...",
    "uri": "https://alerts.weather.gov/"
}
""".data(using: .utf8)!
