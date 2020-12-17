// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Advent of Code",
    dependencies: [
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
        .target(name: "07", dependencies: ["Utility"]),
        .target(name: "08"),
        .target(name: "09"),
        .target(name: "10", dependencies: ["Utility"]),
        .target(name: "11"),
        .target(name: "1201"),
        .target(name: "1202"),
        .target(name: "13"),
        .target(name: "14", dependencies: ["Utility"]),
        .target(name: "15"),
        .target(name: "16", dependencies: ["Utility"]),
        .target(name: "17", dependencies: ["Utility"])
    ]
)
