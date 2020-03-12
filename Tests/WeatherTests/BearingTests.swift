import XCTest
@testable import Weather

final class BearingTests: XCTestCase {
    func testAngle() {
        XCTAssertEqual(Bearing.n.angle, 0.0)
        XCTAssertEqual(Bearing.nne.angle, 22.5)
        XCTAssertEqual(Bearing.ne.angle, 45.0)
        XCTAssertEqual(Bearing.ene.angle, 67.5)
        XCTAssertEqual(Bearing.e.angle, 90.0)
        XCTAssertEqual(Bearing.ese.angle, 112.5)
        XCTAssertEqual(Bearing.se.angle, 135.0)
        XCTAssertEqual(Bearing.sse.angle, 157.5)
        XCTAssertEqual(Bearing.s.angle, 180.0)
        XCTAssertEqual(Bearing.ssw.angle, 202.5)
        XCTAssertEqual(Bearing.sw.angle, 225.0)
        XCTAssertEqual(Bearing.wsw.angle, 247.5)
        XCTAssertEqual(Bearing.w.angle, 270.0)
        XCTAssertEqual(Bearing.wnw.angle, 292.5)
        XCTAssertEqual(Bearing.nw.angle, 315.0)
        XCTAssertEqual(Bearing.nnw.angle, 337.5)
    }
    
    func testAngleInit() {
        XCTAssertNil(Bearing(angle: -0.1))
        XCTAssertEqual(Bearing(angle: 0.0), .n)
        XCTAssertEqual(Bearing(angle: 11.24), .n)
        XCTAssertEqual(Bearing(angle: 11.25), .nne)
        XCTAssertEqual(Bearing(angle: 33.74), .nne)
        XCTAssertEqual(Bearing(angle: 33.75), .ne)
        XCTAssertEqual(Bearing(angle: 56.24), .ne)
        XCTAssertEqual(Bearing(angle: 56.25), .ene)
        XCTAssertEqual(Bearing(angle: 78.74), .ene)
        XCTAssertEqual(Bearing(angle: 78.75), .e)
        XCTAssertEqual(Bearing(angle: 101.24), .e)
        XCTAssertEqual(Bearing(angle: 101.25), .ese)
        XCTAssertEqual(Bearing(angle: 123.74), .ese)
        XCTAssertEqual(Bearing(angle: 123.75), .se)
        XCTAssertEqual(Bearing(angle: 146.24), .se)
        XCTAssertEqual(Bearing(angle: 146.25), .sse)
        XCTAssertEqual(Bearing(angle: 168.74), .sse)
        XCTAssertEqual(Bearing(angle: 168.75), .s)
        XCTAssertEqual(Bearing(angle: 191.24), .s)
        XCTAssertEqual(Bearing(angle: 191.25), .ssw)
        XCTAssertEqual(Bearing(angle: 213.74), .ssw)
        XCTAssertEqual(Bearing(angle: 213.75), .sw)
        XCTAssertEqual(Bearing(angle: 236.24), .sw)
        XCTAssertEqual(Bearing(angle: 236.25), .wsw)
        XCTAssertEqual(Bearing(angle: 258.74), .wsw)
        XCTAssertEqual(Bearing(angle: 258.75), .w)
        XCTAssertEqual(Bearing(angle: 281.24), .w)
        XCTAssertEqual(Bearing(angle: 281.25), .wnw)
        XCTAssertEqual(Bearing(angle: 303.74), .wnw)
        XCTAssertEqual(Bearing(angle: 303.75), .nw)
        XCTAssertEqual(Bearing(angle: 326.24), .nw)
        XCTAssertEqual(Bearing(angle: 326.25), .nnw)
        XCTAssertEqual(Bearing(angle: 348.74), .nnw)
        XCTAssertEqual(Bearing(angle: 348.75), .n)
        XCTAssertEqual(Bearing(angle: 359.9), .n)
        XCTAssertNil(Bearing(angle: 360.0))
    }
}

extension BearingTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let bearings: [Bearing] = try JSONDecoder().decode([Bearing].self, from: BearingTests_Data)
            XCTAssertEqual(bearings, [.ssw, .nne, .e])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let BearingTests_Data: Data = """
[
    208.97,
    15.8,
    92.41
]
""".data(using: .utf8)!
