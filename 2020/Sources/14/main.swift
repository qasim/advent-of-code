import Algorithms
import Foundation
import Utility

// MARK: - Input

let instructions = mainInput
    .components(separatedBy: "\n")
    .map { $0.components(separatedBy: " = ") }
    .map { instruction -> Instruction in
        if instruction[0].starts(with: "mask") {
            return SetMask(mask: instruction[1])
        } else if instruction[0].starts(with: "mem") {
            return SetMemory(address: Int(instruction[0][4..<instruction[0].count - 1])!, value: Int(instruction[1])!)
        } else {
            fatalError("Unsupported instruction")
        }
    }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var program = Program(decoder: .v1)

    for instruction in instructions {
        instruction.perform(on: &program)
    }

    return program.memory.values.sum
}

func part2() -> Any? {
    var program = Program(decoder: .v2)

    for instruction in instructions {
        instruction.perform(on: &program)
    }

    return program.memory.values.sum
}

// MARK: - Types

struct Program {
    let decoder: Decoder
    var mask: String = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    var memory: [Int: Int] = [:]
}

enum Decoder {
    case v1
    case v2
}

protocol Instruction {
    func perform(on program: inout Program)
}

struct SetMask: Instruction {
    let mask: String

    func perform(on program: inout Program) {
        program.mask = mask
    }
}

struct SetMemory: Instruction {
    let address: Int
    let value: Int

    func perform(on program: inout Program) {
        switch program.decoder {
        case .v1: performV1(on: &program)
        case .v2: performV2(on: &program)
        }
    }

    func performV1(on program: inout Program) {
        var binaryValue = value.as36BitBinary

        for (index, bit) in program.mask.enumerated() {
            guard bit != "X" else {
                continue
            }

            binaryValue.replace(index, with: bit)
        }

        program.memory[address] = binaryValue.asDecimal
    }

    func performV2(on program: inout Program) {
        var binaryAddress = address.as36BitBinary

        for (index, bit) in program.mask.enumerated() {
            guard bit != "0" else {
                continue
            }

            binaryAddress.replace(index, with: bit)
        }

        for permutation in "01".permutationsWithRepetition(taking: binaryAddress.numberOfOccurences(of: "X")) {
            var permutedBinaryAddress = binaryAddress
            var permutationIndex = permutation.startIndex

            while let floatingIndex = permutedBinaryAddress.firstIndex(of: "X") {
                permutedBinaryAddress.replace(floatingIndex, with: permutation[permutationIndex])
                permutationIndex = permutation.index(after: permutationIndex)
            }

            program.memory[permutedBinaryAddress.asDecimal!] = value
        }
    }
}

extension Int {
    var as36BitBinary: String {
        let unpaddedBinaryValue = String(self, radix: 2)
        return String(repeating: "0", count: 36 - unpaddedBinaryValue.count) + unpaddedBinaryValue
    }
}

extension String {
    var asDecimal: Int? {
        Int(self, radix: 2)
    }
}
