import Foundation

// MARK: - Input

var layout: [Point: Position] = [:]
mainInput
    .components(separatedBy: "\n")
    .enumerated()
    .forEach { rowIndex, row in
        row
            .enumerated()
            .forEach { columnIndex, type in
                layout[Point(x: rowIndex, y: columnIndex)] = Position(rawValue: type)!
            }
    }

let directionDeltas: [Point] = [
    Point(x: -1, y: -1),
    Point(x: 0, y: -1),
    Point(x: 1, y: -1),
    Point(x: 1, y: 0),
    Point(x: 1, y: 1),
    Point(x: 0, y: 1),
    Point(x: -1, y: 1),
    Point(x: -1, y: 0)
]

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var lastLayout = layout
    var currentLayout = layout.applyFirstSetOfRules()

    while lastLayout != currentLayout {
        lastLayout = currentLayout
        currentLayout = lastLayout.applyFirstSetOfRules()
    }

    return currentLayout.values.filter { $0 == .occupied }.count
}

func part2() -> Any? {
    var lastLayout = layout
    var currentLayout = layout.applySecondSetOfRules()

    while lastLayout != currentLayout {
        lastLayout = currentLayout
        currentLayout = lastLayout.applySecondSetOfRules()
    }

    return currentLayout.values.filter { $0 == .occupied }.count
}

// MARK: - Types

struct Point: Hashable {
    let x: Int
    let y: Int

    func applying(delta: Point) -> Point {
        Point(x: x + delta.x, y: y + delta.y)
    }
}

enum Position: Character {
    case floor = "."
    case empty = "L"
    case occupied = "#"

    var canBeSeenPast: Bool {
        self == .floor
    }
}

extension Dictionary where Key == Point, Value == Position {
    func applyFirstSetOfRules() -> [Point: Position] {
        var positions: [Point: Position] = [:]

        for (point, position) in self {
            switch position {
            case .empty where adjacentPositions(from: point).allSatisfy({ $0 != .occupied }):
                positions[point] = .occupied

            case .occupied where adjacentPositions(from: point).filter({ $0 == .occupied }).count >= 4:
                positions[point] = .empty

            default:
                positions[point] = position
            }
        }

        return positions
    }

    func applySecondSetOfRules() -> [Point: Position] {
        var positions: [Point: Position] = [:]

        for (point, position) in self {
            switch position {
            case .empty where visiblePositions(from: point).allSatisfy({ $0 != .occupied }):
                positions[point] = .occupied

            case .occupied where visiblePositions(from: point).filter({ $0 == .occupied }).count >= 5:
                positions[point] = .empty

            default:
                positions[point] = position
            }
        }

        return positions
    }

    func adjacentPositions(from point: Point) -> [Position] {
        directionDeltas.compactMap { self[point.applying(delta: $0)] }
    }

    func visiblePositions(from point: Point) -> [Position] {
        directionDeltas.compactMap { seatPosition(from: point, delta: $0) }
    }

    func seatPosition(from point: Point, delta: Point) -> Position? {
        var currentPoint = point

        repeat {
            currentPoint = currentPoint.applying(delta: delta)
        } while self[currentPoint] != nil && self[currentPoint]!.canBeSeenPast

        return self[currentPoint]
    }
}
