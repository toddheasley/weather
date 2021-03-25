// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Weather",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "Weather", targets: [
            "Weather"
        ]),
        .executable(name: "weather-cli", targets: [
            "WeatherCLI"
        ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.1")
    ],
    targets: [
        .target(name: "Weather"),
        .target(name: "WeatherCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Weather"
        ]),
        .testTarget(name: "WeatherTests", dependencies: [
            "Weather"
        ])
    ]
)
