import XCTest
import CoreLocation
@testable import Weather

final class ForecastTests: XCTestCase {
    func testRequestURL() {
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.6617, longitude: -70.1961)
        let date: Date = Date()
        
        Forecast.Request.key = "268a49e46c1b588ede555c8b4cc034f4"
        do {
            Forecast.Request.language = .es
            Forecast.Request.units = .si
            var url: URL = try Forecast.Request(coordinate: coordinate, date: date).url()
            XCTAssertEqual(url.absoluteString, "https://api.darksky.net/forecast/268a49e46c1b588ede555c8b4cc034f4/43.6617,-70.1961,\(Int(date.timeIntervalSince1970))?units=si&lang=es")
            Forecast.Request.language = .auto
            Forecast.Request.units = .auto
            url = try Forecast.Request(coordinate: coordinate, blocks: [.current, .minutes, .hours(extended: true), .flags]).url()
            XCTAssertEqual(url.absoluteString, "https://api.darksky.net/forecast/268a49e46c1b588ede555c8b4cc034f4/43.6617,-70.1961?units=us&lang=en&exclude=daily,alerts&extend=hourly")
        } catch {
            switch error as? Forecast.Error {
            case .urlEncodingFailed:
                break
            default:
                XCTFail()
            }
        }
        Forecast.Request.key = nil
        do {
            let _:URL = try Forecast.Request(coordinate: .null).url()
        } catch {
            switch error as? Forecast.Error {
            case .keyNotFound:
                break
            default:
                XCTFail()
            }
        }
    }
    
    func testBlockExcludedCases() {
        XCTAssertEqual(Forecast.Block.excluded(from: []), Forecast.Block.allCases)
        XCTAssertEqual(Forecast.Block.excluded(from: [.hours(extended: true), .days, .flags]), [.current, .minutes, .alerts])
        XCTAssertEqual(Forecast.Block.excluded(from: [.current, .minutes, .flags]), [.hours(extended: false), .days, .alerts])
        XCTAssertTrue(Forecast.Block.excluded(from: Forecast.Block.allCases).isEmpty)
    }
    
    func testBlockAllCases() {
        XCTAssertEqual(Forecast.Block.allCases, [.current, .minutes, .hours(extended: false), .days, .alerts, .flags])
    }
    
    func testAttribution() {
        XCTAssertEqual(Forecast.attribution.url.absoluteString, "https://darksky.net/poweredby")
        XCTAssertEqual(Forecast.attribution.description, "Powered by Dark Sky")
    }
}

extension ForecastTests {
    
    // MARK: Decodable
    func testDecoderInit() {
        do {
            let forecast: Forecast = try JSONDecoder(date: .secondsSince1970, units: .us).decode(Forecast.self, from: ForecastTests_Data)
            XCTAssertEqual(forecast.coordinate.latitude, 43.6617)
            XCTAssertEqual(forecast.timeZone, TimeZone(identifier: "America/New_York"))
            XCTAssertEqual(forecast.units, .us)
            XCTAssertEqual(forecast.current?.date, Date(timeIntervalSince1970: 1522701260.0))
            XCTAssertEqual(forecast.minutes?.points.count, 61)
            XCTAssertEqual(forecast.hours?.points.count, 24)
            XCTAssertEqual(forecast.days?.points.count, 1)
            XCTAssertEqual(forecast.alerts?.first?.title, "Wind Advisory")
            XCTAssertEqual(forecast.flags?.sources.count, 8)
            XCTAssertFalse(forecast.flags?.isUnavailable ?? true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

private let ForecastTests_Data: Data = """
{
    "latitude": 43.6617,
    "longitude": -70.1961,
    "timezone": "America/New_York",
    "currently": {
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
    "minutely": {
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
    },
    "hourly": {
        "summary": "Partly cloudy starting in the morning.",
        "icon": "partly-cloudy-day",
        "data": [
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
                "time": 1522645200,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 30.88,
                "apparentTemperature": 30.88,
                "dewPoint": 16.46,
                "humidity": 0.55,
                "pressure": 1018.94,
                "windSpeed": 2.69,
                "windGust": 3.03,
                "windBearing": 323,
                "cloudCover": 0.01,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 383.96
            },
            {
                "time": 1522648800,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 30.16,
                "apparentTemperature": 30.16,
                "dewPoint": 17.92,
                "humidity": 0.6,
                "pressure": 1018.81,
                "windSpeed": 0.37,
                "windGust": 1.41,
                "windBearing": 348,
                "cloudCover": 0.02,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 384.48
            },
            {
                "time": 1522652400,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 29.28,
                "apparentTemperature": 29.28,
                "dewPoint": 17.28,
                "humidity": 0.6,
                "pressure": 1018.77,
                "windSpeed": 0.68,
                "windGust": 1.2,
                "windBearing": 297,
                "cloudCover": 0.02,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 383.07
            },
            {
                "time": 1522656000,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 30.98,
                "apparentTemperature": 30.98,
                "dewPoint": 18.58,
                "humidity": 0.6,
                "pressure": 1018.99,
                "windSpeed": 1.71,
                "windGust": 2.25,
                "windBearing": 181,
                "cloudCover": 0.03,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 381.39
            },
            {
                "time": 1522659600,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 31.06,
                "apparentTemperature": 31.06,
                "dewPoint": 19.38,
                "humidity": 0.61,
                "pressure": 1019.65,
                "windSpeed": 0.86,
                "windGust": 2.1,
                "windBearing": 165,
                "cloudCover": 0.1,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 380.21
            },
            {
                "time": 1522663200,
                "summary": "Clear",
                "icon": "clear-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 31.15,
                "apparentTemperature": 31.15,
                "dewPoint": 20.07,
                "humidity": 0.63,
                "pressure": 1019.55,
                "windSpeed": 1.18,
                "windGust": 1.3,
                "windBearing": 289,
                "cloudCover": 0.11,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 379.7
            },
            {
                "time": 1522666800,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 31.5,
                "apparentTemperature": 31.5,
                "dewPoint": 20,
                "humidity": 0.62,
                "pressure": 1019.8,
                "windSpeed": 0.73,
                "windGust": 2.43,
                "windBearing": 299,
                "cloudCover": 0.63,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 379.77
            },
            {
                "time": 1522670400,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 33.13,
                "apparentTemperature": 33.13,
                "dewPoint": 21.48,
                "humidity": 0.62,
                "pressure": 1020.69,
                "windSpeed": 1.51,
                "windGust": 3.32,
                "windBearing": 287,
                "cloudCover": 0.72,
                "uvIndex": 0,
                "visibility": 5,
                "ozone": 382.48
            },
            {
                "time": 1522674000,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 34.56,
                "apparentTemperature": 34.56,
                "dewPoint": 20.81,
                "humidity": 0.57,
                "pressure": 1020.9,
                "windSpeed": 1.96,
                "windGust": 2.88,
                "windBearing": 184,
                "cloudCover": 0.53,
                "uvIndex": 1,
                "visibility": 5,
                "ozone": 386.64
            },
            {
                "time": 1522677600,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 33.81,
                "apparentTemperature": 33.81,
                "dewPoint": 20.86,
                "humidity": 0.59,
                "pressure": 1021.09,
                "windSpeed": 2.01,
                "windGust": 3.18,
                "windBearing": 135,
                "cloudCover": 0.67,
                "uvIndex": 2,
                "visibility": 3.71,
                "ozone": 392.16
            },
            {
                "time": 1522681200,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0016,
                "precipProbability": 0.86,
                "precipType": "rain",
                "temperature": 33.34,
                "apparentTemperature": 33.34,
                "dewPoint": 25.38,
                "humidity": 0.72,
                "pressure": 1021.03,
                "windSpeed": 1.49,
                "windGust": 3.92,
                "windBearing": 187,
                "cloudCover": 0.63,
                "uvIndex": 2,
                "visibility": 2.55,
                "ozone": 397.39
            },
            {
                "time": 1522684800,
                "summary": "Light Snow",
                "icon": "snow",
                "precipIntensity": 0.0191,
                "precipProbability": 0.86,
                "precipAccumulation": 0.146,
                "precipType": "snow",
                "temperature": 33.54,
                "apparentTemperature": 33.54,
                "dewPoint": 27.65,
                "humidity": 0.79,
                "pressure": 1020.59,
                "windSpeed": 1.74,
                "windGust": 4.66,
                "windBearing": 176,
                "cloudCover": 0.76,
                "uvIndex": 3,
                "visibility": 2.68,
                "ozone": 402.11
            },
            {
                "time": 1522688400,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.013,
                "precipProbability": 0.86,
                "precipType": "sleet",
                "temperature": 33.21,
                "apparentTemperature": 33.21,
                "dewPoint": 28.87,
                "humidity": 0.84,
                "pressure": 1020.14,
                "windSpeed": 1.43,
                "windGust": 3.19,
                "windBearing": 239,
                "cloudCover": 0.79,
                "uvIndex": 3,
                "visibility": 2.74,
                "ozone": 406.58
            },
            {
                "time": 1522692000,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0167,
                "precipProbability": 0.59,
                "precipType": "rain",
                "temperature": 33.78,
                "apparentTemperature": 33.78,
                "dewPoint": 29.66,
                "humidity": 0.85,
                "pressure": 1019.83,
                "windSpeed": 2.89,
                "windGust": 9.15,
                "windBearing": 165,
                "cloudCover": 0.79,
                "uvIndex": 2,
                "visibility": 4.74,
                "ozone": 409.47
            },
            {
                "time": 1522695600,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.006,
                "precipProbability": 0.59,
                "precipType": "rain",
                "temperature": 34.54,
                "apparentTemperature": 31.93,
                "dewPoint": 29.29,
                "humidity": 0.81,
                "pressure": 1019.53,
                "windSpeed": 3.2,
                "windGust": 4.76,
                "windBearing": 148,
                "cloudCover": 0.68,
                "uvIndex": 2,
                "visibility": 5,
                "ozone": 410.53
            },
            {
                "time": 1522699200,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0021,
                "precipProbability": 0.37,
                "precipAccumulation": 0.016,
                "precipType": "snow",
                "temperature": 35.78,
                "apparentTemperature": 31.62,
                "dewPoint": 30.26,
                "humidity": 0.8,
                "pressure": 1018.87,
                "windSpeed": 4.88,
                "windGust": 7.09,
                "windBearing": 134,
                "cloudCover": 0.38,
                "uvIndex": 1,
                "visibility": 5,
                "ozone": 410.06
            },
            {
                "time": 1522702800,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0001,
                "precipProbability": 0.31,
                "precipAccumulation": 0,
                "precipType": "snow",
                "temperature": 36.67,
                "apparentTemperature": 32.27,
                "dewPoint": 30.64,
                "humidity": 0.79,
                "pressure": 1018.93,
                "windSpeed": 5.36,
                "windGust": 7.43,
                "windBearing": 144,
                "cloudCover": 0.31,
                "uvIndex": 1,
                "visibility": 6.28,
                "ozone": 408.07
            },
            {
                "time": 1522706400,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0018,
                "precipProbability": 0.23,
                "precipAccumulation": 0.014,
                "precipType": "snow",
                "temperature": 36.85,
                "apparentTemperature": 31.52,
                "dewPoint": 30.39,
                "humidity": 0.77,
                "pressure": 1019.24,
                "windSpeed": 6.72,
                "windGust": 9.31,
                "windBearing": 157,
                "cloudCover": 0.32,
                "uvIndex": 0,
                "visibility": 8.13,
                "ozone": 403.8
            },
            {
                "time": 1522710000,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-day",
                "precipIntensity": 0.0003,
                "precipProbability": 0.08,
                "precipAccumulation": 0,
                "precipType": "snow",
                "temperature": 36.47,
                "apparentTemperature": 30.12,
                "dewPoint": 30.11,
                "humidity": 0.77,
                "pressure": 1019.88,
                "windSpeed": 8.31,
                "windGust": 12.3,
                "windBearing": 169,
                "cloudCover": 0.31,
                "uvIndex": 0,
                "visibility": 9.83,
                "ozone": 397.98
            },
            {
                "time": 1522713600,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 35.95,
                "apparentTemperature": 29.29,
                "dewPoint": 30.2,
                "humidity": 0.79,
                "pressure": 1020.39,
                "windSpeed": 8.67,
                "windGust": 12.82,
                "windBearing": 176,
                "cloudCover": 0.29,
                "uvIndex": 0,
                "visibility": 10,
                "ozone": 393
            },
            {
                "time": 1522717200,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 35.57,
                "apparentTemperature": 29.01,
                "dewPoint": 30.59,
                "humidity": 0.82,
                "pressure": 1020.69,
                "windSpeed": 8.33,
                "windGust": 12.56,
                "windBearing": 180,
                "cloudCover": 0.27,
                "uvIndex": 0,
                "visibility": 10,
                "ozone": 389.72
            },
            {
                "time": 1522720800,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 35.4,
                "apparentTemperature": 28.99,
                "dewPoint": 30.82,
                "humidity": 0.83,
                "pressure": 1021.08,
                "windSpeed": 8.01,
                "windGust": 11.97,
                "windBearing": 184,
                "cloudCover": 0.25,
                "uvIndex": 0,
                "visibility": 10,
                "ozone": 387.19
            },
            {
                "time": 1522724400,
                "summary": "Partly Cloudy",
                "icon": "partly-cloudy-night",
                "precipIntensity": 0,
                "precipProbability": 0,
                "temperature": 35.4,
                "apparentTemperature": 29.27,
                "dewPoint": 31.13,
                "humidity": 0.84,
                "pressure": 1021.28,
                "windSpeed": 7.52,
                "windGust": 11.09,
                "windBearing": 187,
                "cloudCover": 0.4,
                "uvIndex": 0,
                "visibility": 10,
                "ozone": 384.9
            }
        ]
    },
    "daily": {
        "data": [
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
    },
    "alerts": [
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
    ],
    "flags": {
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
        "units": "us"
    },
    "offset": -4
}
""".data(using: .utf8)!
