import Foundation
import Weather

extension URLCredentialStorage {
    var key: String? {
        set {
            removeCredentials(for: .key)
            if let newValue: String = newValue, !newValue.isEmpty {
                set(URLCredential(user: Bundle.main.executableName, password: newValue, persistence: .permanent), for: .key)
            }
        }
        get {
            return credentials(for: .key)?.values.first?.password
        }
    }
    
    private func removeCredentials(for protectionSpace: URLProtectionSpace) {
        for credential in (credentials(for: protectionSpace) ?? [:]).values {
            remove(credential, for: protectionSpace)
        }
    }
}

extension URLProtectionSpace {
    fileprivate static let key: URLProtectionSpace = URLProtectionSpace(host: "api.darksky.net", port: 0, protocol: "https", realm: nil, authenticationMethod: nil)
}
