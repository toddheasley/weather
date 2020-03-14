import XCTest
@testable import Weather

final class BlockTests: XCTestCase {
    
}

extension BlockTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let block: Block = try JSONDecoder(date: .secondsSince1970, units: .us).decode(Block.self, from: BlockTests_Data)
            XCTAssertEqual(block.points.count, 61)
            XCTAssertEqual(block.summary, "Partly cloudy for the hour.")
            XCTAssertEqual(block.icon, .partlyCloudyDay)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let BlockTests_Data: Data = """
{
    "summary": "Partly cloudy for the hour.",
    "icon": "partly-cloudy-day",
    "data": [
        {
            "time": 1522701240,
            "precipIntensity": 0,
            "precipProbability": 0
            
        },
        {
            "time": 1522701300,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701360,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701420,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701480,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701540,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701600,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701660,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701720,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701780,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701840,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701900,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522701960,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702020,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702080,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702140,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702200,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702260,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702320,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702380,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702440,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702500,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702560,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702620,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702680,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702740,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702800,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702860,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702920,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522702980,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703040,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703100,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703160,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703220,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703280,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703340,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703400,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703460,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703520,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703580,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703640,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703700,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703760,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703820,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703880,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522703940,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704000,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704060,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704120,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704180,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704240,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704300,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704360,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704420,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704480,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704540,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704600,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704660,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704720,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704780,
            "precipIntensity": 0,
            "precipProbability": 0
        },
        {
            "time": 1522704840,
            "precipIntensity": 0,
            "precipProbability": 0
        }
    ]
}
""".data(using: .utf8)!
