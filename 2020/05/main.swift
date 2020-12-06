import Foundation

let input = try! String(contentsOfFile: "input.txt")
let passes = input
    .split(whereSeparator: \.isNewline)
    .map { specifier in
        Pass(specifier: String(specifier))
    }

print("Part 1: \(part1(passes))")
print("Part 2: \(part2(passes))")

func part1(_ passes: [Pass]) -> Int {
    passes.map(\.seatID).max()!
}

func part2(_ passes: [Pass]) -> Int {
    missingSeatID(existingPasses: passes)!
}

func missingSeatID(existingPasses: [Pass]) -> Int? {
    let existingSeatIDs = existingPasses.map(\.seatID).sorted()

    guard let firstSeatID = existingSeatIDs.first, let lastSeatID = existingSeatIDs.last else {
        return nil
    }

    let allPossibleSeatIDs = Set(firstSeatID...lastSeatID)
    return allPossibleSeatIDs.subtracting(Set(existingSeatIDs)).first
}

struct Pass {
    let specifier: String

    var row: Int {
        var min = 0
        var max = 128

        for instruction in specifier.prefix(7) {
            switch instruction {
            case "F": max -= (max - min) / 2
            case "B": min += (max - min) / 2
            default: continue
            }
        }

        return min
    }

    var column: Int {
        var min = 0
        var max = 8

        for instruction in specifier.suffix(3) {
            switch instruction {
            case "L": max -= (max - min) / 2
            case "R": min += (max - min) / 2
            default: continue
            }
        }

        return min
    }

    var seatID: Int {
        row * 8 + column
    }
}
