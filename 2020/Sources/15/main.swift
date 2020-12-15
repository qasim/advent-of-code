import Foundation

// MARK: - Input

let startingNumbers = mainInput.components(separatedBy: ",").compactMap(Int.init)

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    startingNumbers.lastNumberSpoken(after: 2020)
}

func part2() -> Any? {
    startingNumbers.lastNumberSpoken(after: 30_000_000)
}

// MARK: - Types

extension Array where Element == Int {
    func lastNumberSpoken(after numberOfTurns: Int) -> Int {
        var startingNumbers = self

        var lastNumberSpoken = -1
        var nextNumberSpoken = startingNumbers.removeLast()

        var lastTurnOf = [Int: Int]()

        for (turn, startingNumber) in startingNumbers.enumerated() {
            lastTurnOf[startingNumber] = turn
        }

        for turn in startingNumbers.endIndex..<numberOfTurns {
            lastNumberSpoken = nextNumberSpoken

            if let lastTurn = lastTurnOf[lastNumberSpoken] {
                nextNumberSpoken = turn - lastTurn
            } else {
                nextNumberSpoken = 0
            }

            lastTurnOf[lastNumberSpoken] = turn
        }

        return lastNumberSpoken
    }
}
