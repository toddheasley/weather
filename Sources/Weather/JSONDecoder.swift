import Foundation

extension JSONDecoder {
    convenience init(date decodingStrategy: DateDecodingStrategy, units: Units = .auto) {
        self.init()
        dateDecodingStrategy = decodingStrategy
        userInfo[.units] = units
    }
}

extension Decoder {
    func units() throws -> Units {
        guard let units: Units = userInfo[.units] as? Units else {
            throw DecodingError.valueNotFound(Units.self, DecodingError.Context(codingPath: [], debugDescription: ""))
        }
        return units
    }
}

extension CodingUserInfoKey {
    fileprivate static let units: CodingUserInfoKey = CodingUserInfoKey(rawValue: "units")!
}

extension CodingKey {
    var intValue: Int? {
        return nil
    }
    
    init?(intValue: Int) {
        return nil
    }
}
