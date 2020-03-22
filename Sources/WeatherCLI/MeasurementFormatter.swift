import Foundation

extension MeasurementFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = numberStyle
    }
}
