import XCTest
@testable import Weather

final class SourceTests: XCTestCase {
    
}

extension SourceTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let sources: [Source] = try JSONDecoder().decode([Source].self, from: SourceTests_Data)
            XCTAssertEqual(sources.map { $0.name }, ["darksky", "lamp", "madis"])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let SourceTests_Data: Data = """
[
    "darksky",
    "lamp",
    "madis"
]
""".data(using: .utf8)!
