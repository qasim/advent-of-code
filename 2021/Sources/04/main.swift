import Foundation
import Utility

// MARK: - Parsing

let blocks = mainInput.components(separatedBy: "\n\n")

let numbersToDraw = blocks[0]
    .split(separator: ",")
    .compactMap { Int($0) }

let boards = blocks[1...].map { block -> Board in
    block
        .split(separator: "\n")
        .map { line -> [Int] in
            line
                .split(separator: " ", omittingEmptySubsequences: true)
                .compactMap { Int($0) }
        }
        .enumerated()
        .reduce(into: Board()) { result, line in
            let y = line.offset
            for number in line.element.enumerated() {
                result.positions.append(
                    .init(point: .init(x: number.offset, y: y), number: number.element, isMarked: false)
                )
            }
        }
}

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var boards = boards
    
    for number in numbersToDraw {
        var i = boards.startIndex
        while i < boards.endIndex {
            boards[i].mark(drawnNumber: number)
            if boards[i].isWinner {
                return boards[i].score(lastDrawnNumber: number)
            }
            i = boards.index(after: i)
        }
    }
    
    return nil
}

func part2() -> Any? {
    var boards = boards
    
    for number in numbersToDraw {
        var i = boards.startIndex
        while i < boards.endIndex {
            boards[i].mark(drawnNumber: number)
            if boards[i].isWinner {
                if boards.count == 1 {
                    return boards[i].score(lastDrawnNumber: number)
                }
                boards.remove(at: i)
            } else {
                i = boards.index(after: i)
            }
        }
    }
    
    return nil
}

// MARK: - Types

struct Point: Equatable {
    let x, y: Int
}

struct Position: Equatable {
    let point: Point
    let number: Int
    var isMarked: Bool
}

struct Board: Equatable {
    var positions: [Position] = []
    
    static let winningPositionSets: [[Point]] = [
        [.init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0), .init(x: 3, y: 0), .init(x: 4, y: 0)],
        [.init(x: 0, y: 1), .init(x: 1, y: 1), .init(x: 2, y: 1), .init(x: 3, y: 1), .init(x: 4, y: 1)],
        [.init(x: 0, y: 2), .init(x: 1, y: 2), .init(x: 2, y: 2), .init(x: 3, y: 2), .init(x: 4, y: 2)],
        [.init(x: 0, y: 3), .init(x: 1, y: 3), .init(x: 2, y: 3), .init(x: 3, y: 3), .init(x: 4, y: 3)],
        [.init(x: 0, y: 4), .init(x: 1, y: 4), .init(x: 2, y: 4), .init(x: 3, y: 4), .init(x: 4, y: 4)],
        [.init(x: 0, y: 0), .init(x: 0, y: 1), .init(x: 0, y: 2), .init(x: 0, y: 3), .init(x: 0, y: 4)],
        [.init(x: 1, y: 0), .init(x: 1, y: 1), .init(x: 1, y: 2), .init(x: 1, y: 3), .init(x: 1, y: 4)],
        [.init(x: 2, y: 0), .init(x: 2, y: 1), .init(x: 2, y: 2), .init(x: 2, y: 3), .init(x: 2, y: 4)],
        [.init(x: 3, y: 0), .init(x: 3, y: 1), .init(x: 3, y: 2), .init(x: 3, y: 3), .init(x: 3, y: 4)],
        [.init(x: 4, y: 0), .init(x: 4, y: 1), .init(x: 4, y: 2), .init(x: 4, y: 3), .init(x: 4, y: 4)],
    ]
    
    var isWinner: Bool {
        Self.winningPositionSets.contains { positionSet in
            positionSet
                .compactMap { point in
                    positions.first(where: { $0.point == point })
                }
                .allSatisfy(\.isMarked)
        }
    }
    
    func score(lastDrawnNumber number: Int) -> Int {
        number * positions.filter({ !$0.isMarked }).map(\.number).sum
    }
    
    mutating func mark(drawnNumber number: Int) {
        guard let indexToMark = positions.firstIndex(where: { $0.number == number }) else {
            return
        }
        positions[indexToMark].isMarked = true
    }
}
