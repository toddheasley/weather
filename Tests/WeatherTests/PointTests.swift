import XCTest
@testable import Weather

final class PointTests: XCTestCase {
    
}

extension PointTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let points: [Point] = try JSONDecoder(date: .secondsSince1970, units: .us).decode([Point].self, from: PointTests_Data)
            guard points.count == 4 else {
                XCTFail()
                return
            }
            XCTAssertEqual(points[0].date, Date(timeIntervalSince1970: 1522701260.0))
            XCTAssertNotNil(points[0].temperature)
            XCTAssertNotNil(points[0].precipitation)
            XCTAssertEqual(points[0].cloudCover, 0.34)
            XCTAssertNotNil(points[0].dewPoint)
            XCTAssertEqual(points[0].humidity, 0.79)
            XCTAssertEqual(points[0].ozone, 408.92)
            XCTAssertEqual(points[0].pressure, Measurement(value: 1018.9, unit: Units.us.pressure))
            XCTAssertEqual(points[0].visibility, Measurement(value: 5.73, unit: Units.us.distance))
            XCTAssertNotNil(points[0].wind)
            XCTAssertNotNil(points[0].uvIndex)
            XCTAssertEqual(points[0].summary, "Partly Cloudy")
            XCTAssertEqual(points[0].icon, .partlyCloudyDay)
            XCTAssertEqual(points[1].date, Date(timeIntervalSince1970: 1522701240.0))
            XCTAssertNotNil(points[1].precipitation)
            XCTAssertEqual(points[2].date, Date(timeIntervalSince1970: 1522641600.0))
            XCTAssertNotNil(points[2].temperature)
            XCTAssertNotNil(points[2].precipitation)
            XCTAssertEqual(points[2].cloudCover, 0.07)
            XCTAssertNotNil(points[2].dewPoint)
            XCTAssertEqual(points[2].humidity, 0.48)
            XCTAssertEqual(points[2].ozone, 384.81)
            XCTAssertEqual(points[2].pressure, Measurement(value: 1018.95, unit: Units.us.pressure))
            XCTAssertEqual(points[2].visibility, Measurement(value: 5.0, unit: Units.us.distance))
            XCTAssertNotNil(points[2].wind)
            XCTAssertNotNil(points[2].uvIndex)
            XCTAssertEqual(points[2].summary, "Clear")
            XCTAssertEqual(points[2].icon, .clearNight)
            XCTAssertEqual(points[3].date, Date(timeIntervalSince1970: 1522641600.0))
            XCTAssertNotNil(points[3].temperatureInterval)
            XCTAssertNotNil(points[3].precipitation)
            XCTAssertEqual(points[3].cloudCover, 0.38)
            XCTAssertNotNil(points[3].dewPoint)
            XCTAssertEqual(points[3].humidity, 0.7)
            XCTAssertEqual(points[3].ozone, 392.48)
            XCTAssertEqual(points[3].pressure, Measurement(value: 1019.9, unit: Units.us.pressure))
            XCTAssertEqual(points[3].visibility, Measurement(value: 5.96, unit: Units.us.distance))
            XCTAssertNotNil(points[3].wind)
            XCTAssertNotNil(points[3].uvIndex)
            XCTAssertEqual(points[3].sun, DateInterval(start: Date(timeIntervalSince1970: 1522664476.0), duration: 46093.0))
            XCTAssertEqual(points[3].moonPhase, MoonPhase(value: 0.58))
            XCTAssertEqual(points[3].summary, "Partly cloudy throughout the day.")
            XCTAssertEqual(points[3].icon, .partlyCloudyDay)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let PointTests_Data: Data = """
[
    {
        "time": 1522701260,
        "summary": "Partly Cloudy",
        "icon": "partly-cloudy-day",
        "precipIntensity": 0,
        "precipProbability": 0,
        "temperature": 36.29,
        "apparentTemperature": 32,
        "dewPoint": 30.48,
        "humidity": 0.79,
        "pressure": 1018.9,
        "windSpeed": 5.14,
        "windGust": 7.29,
        "windBearing": 140,
        "cloudCover": 0.34,
        "uvIndex": 1,
        "visibility": 5.73,
        "ozone": 408.92
    },
    {
        "time": 1522701240,
        "precipIntensity": 0,
        "precipProbability": 0
    },
    {
        "time": 1522641600,
        "summary": "Clear",
        "icon": "clear-night",
        "precipIntensity": 0,
        "precipProbability": 0,
        "temperature": 32.86,
        "apparentTemperature": 32.86,
        "dewPoint": 15.43,
        "humidity": 0.48,
        "pressure": 1018.95,
        "windSpeed": 1.64,
        "windGust": 2.26,
        "windBearing": 2,
        "cloudCover": 0.07,
        "uvIndex": 0,
        "visibility": 5,
        "ozone": 384.81
    },
    {
        "time": 1522641600,
        "summary": "Partly cloudy throughout the day.",
        "icon": "partly-cloudy-day",
        "sunriseTime": 1522664476,
        "sunsetTime": 1522710569,
        "moonPhase": 0.58,
        "precipIntensity": 0.0025,
        "precipIntensityMax": 0.0191,
        "precipIntensityMaxTime": 1522684800,
        "precipProbability": 0.2,
        "precipAccumulation": 0.179,
        "precipType": "snow",
        "temperatureHigh": 36.85,
        "temperatureHighTime": 1522706400,
        "temperatureLow": 35.4,
        "temperatureLowTime": 1522724400,
        "apparentTemperatureHigh": 34.56,
        "apparentTemperatureHighTime": 1522674000,
        "apparentTemperatureLow": 28.94,
        "apparentTemperatureLowTime": 1522731600,
        "dewPoint": 24.72,
        "humidity": 0.7,
        "pressure": 1019.9,
        "windSpeed": 2.69,
        "windGust": 12.82,
        "windGustTime": 1522713600,
        "windBearing": 174,
        "cloudCover": 0.38,
        "uvIndex": 3,
        "uvIndexTime": 1522684800,
        "visibility": 5.96,
        "ozone": 392.48,
        "temperatureMin": 29.28,
        "temperatureMinTime": 1522652400,
        "temperatureMax": 36.85,
        "temperatureMaxTime": 1522706400,
        "apparentTemperatureMin": 28.99,
        "apparentTemperatureMinTime": 1522720800,
        "apparentTemperatureMax": 34.56,
        "apparentTemperatureMaxTime": 1522674000
    }
]

""".data(using: .utf8)!
