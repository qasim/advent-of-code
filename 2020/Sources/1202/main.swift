import Foundation

// MARK: - Input

let instructions = mainInput
    .components(separatedBy: "\n")
    .map { instruction -> Instruction in
        let code = instruction[instruction.startIndex]
        let value = Int(instruction[instruction.index(after: instruction.startIndex)...])!

        switch code {
        case "N", "S", "E", "W":
            return MoveWaypoint(direction: Direction(rawValue: code)!, value: value)

        case "L", "R":
            return RotateWaypoint(orientation: Orientation(rawValue: code)!, degrees: value)

        case "F":
            return MoveShip(times: value)

        default:
            fatalError("Unsupported instruction code")
        }
    }

// MARK: - Main

print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part2() -> Any? {
    let origin = Point(x: 0, y: 0)
    let waypoint = Point(x: 10, y: 1)
    var ship = Ship(location: origin, waypoint: waypoint)

    for instruction in instructions {
        instruction.perform(on: &ship)
    }

    return ship.location.manhattanDistance(from: origin)
}

// MARK: - Types

protocol Instruction {
    func perform(on ship: inout Ship)
}

struct MoveWaypoint: Instruction {
    let direction: Direction
    let value: Int

    func perform(on ship: inout Ship) {
        switch direction {
        case .north: ship.waypoint.y += value
        case .south: ship.waypoint.y -= value
        case .east:  ship.waypoint.x += value
        case .west:  ship.waypoint.x -= value
        }
    }
}

struct RotateWaypoint: Instruction {
    let orientation: Orientation
    let degrees: Int

    func perform(on ship: inout Ship) {
        ship.waypoint = ship.waypoint.rotating(orientation, times: degrees / 90)
    }
}

struct MoveShip: Instruction {
    let times: Int

    func perform(on ship: inout Ship) {
        ship.location.x += ship.waypoint.x * times
        ship.location.y += ship.waypoint.y * times
    }
}

struct Ship {
    var location: Point
    var waypoint: Point
}

struct Point {
    var x: Int
    var y: Int

    func manhattanDistance(from origin: Point) -> Int {
        abs(origin.x - x) + abs(origin.y - y)
    }

    func rotating(_ orientation: Orientation) -> Point {
        switch orientation {
        case .left:  return Point(x: -y, y: x)
        case .right: return Point(x: y, y: -x)
        }
    }

    func rotating(_ orientation: Orientation, times: Int) -> Point {
        var point = self

        for _ in 0..<times {
            point = point.rotating(orientation)
        }

        return point
    }
}

enum Direction: Character {
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"
}

enum Orientation: Character {
    case left = "L"
    case right = "R"
}
