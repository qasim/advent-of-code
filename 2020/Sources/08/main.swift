import Foundation
import Utility

// MARK: - Main

let instructions = mainInput
    .components(separatedBy: "\n")
    .map { instruction -> Instruction in
        let tokens = instruction.components(separatedBy: " ")
        return Instruction(
            operation: Operation(rawValue: tokens[0])!,
            value: Int(tokens[1]) ?? 0
        )
    }

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    switch instructions.run() {
    case let .success(accumulator), let .failure(accumulator):
        return accumulator
    }
}

func part2() -> Any? {
    for (index, instruction) in instructions.enumerated() {
        var modifiedInstructions = instructions
        switch instruction.operation {
        case .jmp: modifiedInstructions[index] = Instruction(operation: .nop, value: instruction.value)
        case .nop: modifiedInstructions[index] = Instruction(operation: .jmp, value: instruction.value)
        case .acc: continue
        }

        switch modifiedInstructions.run() {
        case let .success(accumulator):
            return accumulator

        case .failure:
            continue
        }
    }

    return nil
}

// MARK: - Types

struct Instruction {
    let operation: Operation
    let value: Int
}

enum Operation: String {
    case acc
    case jmp
    case nop
}

extension Array where Element == Instruction {
    func run(accumulator: Int = 0, index: Int = 0, visitedIndices: [Int] = []) -> Result<Int, Int> {
        guard index < count else {
            return .success(accumulator)
        }

        guard !visitedIndices.contains(index) else {
            return .failure(accumulator)
        }

        let instruction = self[index]

        switch instruction.operation {
        case .acc:
            return run(
                accumulator: accumulator + instruction.value,
                index: index + 1,
                visitedIndices: visitedIndices + [index]
            )

        case .jmp:
            return run(
                accumulator: accumulator,
                index: index + instruction.value,
                visitedIndices: visitedIndices + [index]
            )

        case .nop:
            return run(
                accumulator: accumulator,
                index: index + 1,
                visitedIndices: visitedIndices + [index]
            )
        }
    }
}

extension Int: Error {}
