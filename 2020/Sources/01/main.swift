import Foundation

// MARK: - Main

let entries = mainInput
    .components(separatedBy: "\n")
    .compactMap(Int.init)

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    for x in entries {
        for y in entries {
            if x + y == 2020 {
                return x * y
            }
        }
    }
    return nil
}

func part2() -> Any? {
    for x in entries {
        for y in entries {
            for z in entries {
                if x + y + z == 2020 {
                    return x * y * z
                }
            }
        }
    }
    return nil
}
