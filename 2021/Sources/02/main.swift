import Foundation
import Utility

// MARK: - Parsing

enum Operation: Substring {
    case forward
    case down
    case up
}

struct Instruction {
    let operation: Operation
    let units: Int
}

let instructions = mainInput
    .split(separator: "\n")
    .map { line -> Instruction in
        let tokens = line.split(separator: " ")
        return Instruction(
            operation: .init(rawValue: tokens[0])!,
            units: Int(tokens[1])!
        )
    }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var horizontalPosition = 0
    var depth = 0

    for instruction in instructions {
        switch instruction.operation {
        case .forward: horizontalPosition += instruction.units
        case .down: depth += instruction.units
        case .up: depth -= instruction.units
        }
    }

    return horizontalPosition * depth
}

func part2() -> Any? {
    var horizontalPosition = 0
    var depth = 0
    var aim = 0

    for instruction in instructions {
        switch instruction.operation {
        case .forward:
            horizontalPosition += instruction.units
            depth += aim * instruction.units
        case .down:
            aim += instruction.units
        case .up:
            aim -= instruction.units
        }
    }

    return horizontalPosition * depth
}
