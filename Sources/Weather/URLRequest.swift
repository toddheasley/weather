import Foundation

extension URLRequest {
    var gzip: Bool {
        set {
            setValue(newValue ? "gzip" : nil, forHTTPHeaderField: "Accept-Encoding")
        }
        get {
            return (value(forHTTPHeaderField: "Accept-Encoding") ?? "") == "gzip"
        }
    }
    
    init(url: URL, gzip: Bool, cachePolicy: CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) {
        self.init(url: url)
        self.cachePolicy = cachePolicy ?? self.cachePolicy
        self.timeoutInterval = timeoutInterval ?? self.timeoutInterval
        self.gzip = gzip
    }

}
