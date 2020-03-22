# `Weather`

`Weather` implements the complete [Dark Sky API](https://darksky.net/dev) for [Swift Package Manager.](https://github.com/apple/swift-package-manager)  It's fast and modular, leveraging `Codable` for serialization and `URLSession` for transport. Errors are concise and enumerated -- no mysteries and no surprises. It works with Core Location out of the box.

It's the absolute easiest way to add local (and localized) weather forecasts to any app on every Apple platform.

[![Powered by Dark Sky](DarkSky.svg)](https://darksky.net/poweredby)

## Command-Line Interface

Included in the package

![](Weather.png)

## Requirements

Targets [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad)/[tvOS ](https://developer.apple.com/tvos) 13, as well as [watchOS](https://developer.apple.com/watchos) 6 and [macOS](https://developer.apple.com/macos) 10.15 Catalina. Written in [Swift](https://developer.apple.com/documentation/swift) 5.2 using the [Foundation](https://developer.apple.com/documentation/foundation) and [Core Location](https://developer.apple.com/documentation/corelocation) frameworks and requires [Xcode](https://developer.apple.com/xcode) 11.4 or newer to build. Command-line interface depends on [Swift Argument Parser.](https://github.com/apple/swift-argument-parser)

## Example Usage



```swift
import Foundation
import Weather

```

```shell

```

















# `TankUtility`

`TankUtility` is a Swift package that wraps the [Tank Utility API](http://apidocs.tankutility.com) and handles the following nonsense:

* Persisting Tank Utility authentication securely using [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
* Requesting data from the Tank Utility API via HTTPS
* Returning practical errors when API requests fail
* Modeling device readings and metadata

## Requirements

Supports apps targeting [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad)/[tvOS ](https://developer.apple.com/tvos) 13, as well as [watchOS](https://developer.apple.com/watchos) 6 and [macOS](https://developer.apple.com/macos) 10.15 Catalina. Written in [Swift](https://developer.apple.com/documentation/swift) 5.1 using the [Foundation](https://developer.apple.com/documentation/foundation) framework and requires [Xcode](https://developer.apple.com/xcode) 11 or newer to build.

## Example Usage

Optionally configure `TankUtility` with an app group to enable `UserDefaults` and Keychain access in a shared container.

Authorize with any Tank Utility account:

```swift
import Foundation
import TankUtility

TankUtility.appGroup = "group.example.tankutility"

TankUtility.authorize(username: "tankutility@example.com", password: "********") { error in
    print(error)
}

```

> Authorize with the email address `tankutility@example.com` and any non-empty password to access a bundled example account, useful for testing or just being a tourist. Example account behaves like a real Tank Utility account but makes no networking requests to the Tank Utility API.

Retrieve all devices for authorized account:

```swift
import Foundation
import TankUtility

TankUtility.devices { devices, error in
    guard let devices: [Device] = devices else {
        print(error)
        return
    }
    print(devices)
}

```

Refresh an individual device using device ID:

```swift
import Foundation
import TankUtility

TankUtility.device(id: "000f0031353730350d473731") { device, finished, error in
    guard let device: Device = device else {
        print(error)
        return
    }
    print(device)
}

```

Reset `UserDefaults` and delete authorized account from Keychain:

```swift
import Foundation
import TankUtility

TankUtility.deauthorize()

```
