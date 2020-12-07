// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Advent of Code",
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", .upToNextMinor(from: "0.0.2")),
        .package(url: "https://github.com/sharplet/Regex", .upToNextMinor(from: "2.1.1"))
    ],
    targets: [
        .target(name: "Utility"),
        .target(name: "01"),
        .target(name: "02", dependencies: ["Regex", "Utility"]),
        .target(name: "03"),
        .target(name: "04"),
        .target(name: "05"),
        .target(name: "06"),
        .target(name: "07", dependencies: ["Utility"])
    ]
)
