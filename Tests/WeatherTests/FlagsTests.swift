import XCTest
@testable import Weather

final class FlagsTests: XCTestCase {
    
}

extension FlagsTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let flags: Flags = try JSONDecoder().decode(Flags.self, from: FlagsTests_Data)
            XCTAssertEqual(flags.units, .us)
            XCTAssertEqual(flags.sources.count, 8)
            for source in flags.sources {
                switch source.name {
                case "isd":
                    XCTAssertEqual(source.stations?.count, 16)
                default:
                    XCTAssertNil(source.stations)
                }
            }
            XCTAssertEqual(flags.nearestStation, Measurement(value: 34, unit: Units.us.distance))
            XCTAssertTrue(flags.isUnavailable)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let FlagsTests_Data: Data = """
{
    "sources": [
        "isd",
        "cmc",
        "gfs",
        "hrrr",
        "madis",
        "nam",
        "sref",
        "darksky"
    ],
    "isd-stations": [
        "726060-14764",
        "726065-99999",
        "726066-99999",
        "726087-99999",
        "726156-99999",
        "726184-94709",
        "726184-99999",
        "743920-14611",
        "743925-99999",
        "743927-99999",
        "992780-99999",
        "997275-99999",
        "998015-99999",
        "999999-14611",
        "999999-14764",
        "999999-94734"
    ],
    "nearest-station": 34,
    "darksky-unavailable": "Dark Sky covers the given location, but all stations are currently unavailable.",
    "units": "us"
}
""".data(using: .utf8)!
