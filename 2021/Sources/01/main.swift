import Foundation
import Utility

// MARK: - Parsing

let depths = mainInput
    .split(separator: "\n")
    .compactMap { Int($0) }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var increases = 0

    var i = 0
    while i < depths.count - 1 {
        if depths[i] < depths[i + 1] {
            increases += 1
        }
        i += 1
    }

    return increases
}

func part2() -> Any? {
    var increases = 0

    var i = 2
    while i < depths.count - 1 {
        if depths[i - 2...i].sum < depths[i - 1...i + 1].sum {
            increases += 1
        }
        i += 1
    }

    return increases
}
