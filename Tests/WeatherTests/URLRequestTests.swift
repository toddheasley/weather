import XCTest
@testable import Weather

final class URLRequestTests: XCTestCase {
    
}

extension URLRequestTests {
    func testGzip() {
        var request: URLRequest = URLRequest(url: URL(string: "https://darksky.net")!)
        XCTAssertFalse(request.gzip)
        request.gzip = true
        XCTAssertTrue(request.gzip)
        request.gzip = false
        XCTAssertFalse(request.gzip)
    }
}
