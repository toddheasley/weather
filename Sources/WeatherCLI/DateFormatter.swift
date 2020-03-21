import Foundation

extension DateFormatter {
    convenience init(timeZone: TimeZone) {
        self.init()
        self.timeZone = timeZone
    }
}
