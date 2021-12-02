// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Advent of Code",
    dependencies: [
        .package(url: "https://github.com/sharplet/Regex", .upToNextMinor(from: "2.1.1"))
    ],
    targets: [
        .target(name: "Utility"),
        .target(name: "01", dependencies: ["Utility"]),
        .target(name: "02", dependencies: ["Utility"]),
    ]
)
