// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Advent of Code",
    dependencies: [],
    targets: [
        .target(name: "Utility"),
        .target(name: "01", dependencies: ["Utility"]),
        .target(name: "02", dependencies: ["Utility"]),
        .target(name: "03", dependencies: ["Utility"]),
    ]
)
