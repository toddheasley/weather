import XCTest
import CoreLocation
@testable import Weather

final class CLLocationCoordinate2DTests: XCTestCase {
    
}

extension CLLocationCoordinate2DTests {
    func testNull() {
        XCTAssertEqual(CLLocationCoordinate2D.null.latitude, 0.0)
        XCTAssertEqual(CLLocationCoordinate2D.null.longitude, 0.0)
    }
}

extension CLLocationCoordinate2DTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let coordinate: CLLocationCoordinate2D = try JSONDecoder().decode(CLLocationCoordinate2D.self, from: CLLocationCoordinate2DTests_Data)
            XCTAssertEqual(coordinate.latitude, 43.6617)
            XCTAssertEqual(coordinate.longitude, -70.1961)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let CLLocationCoordinate2DTests_Data: Data = """
{
    "latitude": 43.6617,
    "longitude": -70.1961,
}
""".data(using: .utf8)!
