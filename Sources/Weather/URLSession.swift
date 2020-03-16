import Foundation

extension URLSession {
    func forecast(with request: Forecast.Request, dispatch queue: DispatchQueue = .main, completion: @escaping (Forecast?, Forecast.Error?) -> Void) {
        do {
            dataTask(with: URLRequest(url: try request.url(), gzip: true)) { data, response, error in
                do {
                    switch (response as? HTTPURLResponse)?.statusCode {
                    case 401:
                        throw Forecast.Error.keyNotRecognized
                    case 200:
                        guard let data: Data = data else {
                            throw Forecast.Error.dataCorrupted
                        }
                        let forecast: Forecast = try JSONDecoder(date: .secondsSince1970, units: Forecast.Request.units).decode(Forecast.self, from: data)
                        guard !(forecast.flags?.isUnavailable ?? false) else {
                            throw Forecast.Error.forecastNotAvailable
                        }
                        queue.async {
                            completion(forecast, nil)
                        }
                    default:
                        throw error ?? Forecast.Error.networkRequestFailed
                    }
                } catch {
                    queue.async {
                        completion(nil, (error as? Forecast.Error) ?? .networkRequestFailed)
                    }
                }
            }.resume()
        } catch {
            queue.asyncAfter(deadline: .now() + 0.1) {
                completion(nil, (error as? Forecast.Error) ?? .urlEncodingFailed)
            }
        }
    }
}
