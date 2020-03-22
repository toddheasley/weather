import XCTest
@testable import Weather

final class URLSessionTests: XCTestCase {
    
}

extension URLSessionTests {
    func testForecast() {
        let expectations: [XCTestExpectation] = [
            expectation(description: ""),
            expectation(description: "")
        ]
        let request: Forecast.Request = Forecast.Request(coordinate: .null)
        Forecast.Request.key = "268a49e46c1b588ede555c8b4cc034f4"
        URLSession.shared.forecast(with: request) { forecast, error in
            switch error {
            case .keyNotRecognized:
                break
            default:
                XCTFail()
            }
            expectations[0].fulfill()
        }
        Forecast.Request.key = nil
        URLSession.shared.forecast(with: request) { forecast, error in
            switch error {
            case .keyNotFound:
                break
            default:
                XCTFail()
            }
            expectations[1].fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
