import Foundation

// MARK: - Input

let instructions = mainInput
    .components(separatedBy: "\n")
    .map { instruction -> Instruction in
        let code = instruction[instruction.startIndex]
        let value = Int(instruction[instruction.index(after: instruction.startIndex)...])!

        switch code {
        case "N", "S", "E", "W", "F":
            return Move(direction: Direction(rawValue: code), value: value)

        case "L", "R":
            return Turn(orientation: Orientation(rawValue: code)!, degrees: value)

        default:
            fatalError("Unsupported instruction code")
        }
    }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    let origin = Point(x: 0, y: 0)
    var ship = Ship(location: origin, direction: .east)

    for instruction in instructions {
        instruction.perform(on: &ship)
    }

    return ship.location.manhattanDistance(from: origin)
}

// MARK: - Types

struct Ship {
    var location: Point
    var direction: Direction
}

protocol Instruction {
    func perform(on ship: inout Ship)
}

struct Move: Instruction {
    let direction: Direction?
    let value: Int

    func perform(on ship: inout Ship) {
        switch direction ?? ship.direction {
        case .north: ship.location.y += value
        case .south: ship.location.y -= value
        case .east:  ship.location.x += value
        case .west:  ship.location.x -= value
        }
    }
}

struct Turn: Instruction {
    let orientation: Orientation
    let degrees: Int

    func perform(on ship: inout Ship) {
        ship.direction = ship.direction.rotating(orientation, times: degrees / 90)
    }
}

struct Point {
    var x: Int
    var y: Int

    func manhattanDistance(from origin: Point) -> Int {
        abs(origin.x - x) + abs(origin.y - y)
    }
}

enum Direction: Character {
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"

    func rotating(_ orientation: Orientation) -> Direction {
        switch orientation {
        case .left:
            switch self {
            case .north: return .west
            case .south: return .east
            case .east: return .north
            case .west: return .south
            }

        case .right:
            switch self {
            case .north: return .east
            case .south: return .west
            case .east: return .south
            case .west: return .north
            }
        }
    }

    func rotating(_ orientation: Orientation, times: Int) -> Direction {
        var direction = self

        for _ in 0..<times {
            direction = direction.rotating(orientation)
        }

        return direction
    }
}

enum Orientation: Character {
    case left = "L"
    case right = "R"
}
