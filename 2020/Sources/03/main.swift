import Foundation

// MARK: - Main

let rows = mainInput
    .components(separatedBy: "\n")
    .enumerated()
    .map { y, row in
        row
            .enumerated()
            .map { x, value in
                Coordinate(point: Point(x: x, y: y), type: value == "." ? .open : .tree)
            }
    }

let grid = Grid(dimensions: Point(x: rows[0].count, y: rows.count), coordinates: rows.reduce([], +))

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    grid.treeEncounters(slope: Point(x: 3, y: 1))
}

func part2() -> Any? {
    let slopes = [
        Point(x: 1, y: 1),
        Point(x: 3, y: 1),
        Point(x: 5, y: 1),
        Point(x: 7, y: 1),
        Point(x: 1, y: 2)
    ]

    return slopes
        .map { grid.treeEncounters(slope: $0)}
        .reduce(1, *)
}

// MARK: - Types

struct Grid {
    let dimensions: Point
    let coordinates: [Coordinate]

    func treeEncounters(slope: Point) -> Int {
        var total = 0

        var currentX = 0
        var currentY = 0

        while currentY < dimensions.y {
            if type(at: Point(x: currentX, y: currentY)) == .tree {
                total += 1
            }

            currentX += slope.x
            if currentX >= dimensions.x {
                currentX -= dimensions.x
            }

            currentY += slope.y
        }

        return total
    }

    func type(at point: Point) -> Type? {
        coordinates.first(where: { $0.point.x == point.x && $0.point.y == point.y })?.type
    }
}

struct Coordinate {
    let point: Point
    let type: Type
}

struct Point {
    let x: Int
    let y: Int
}

enum Type {
    case open
    case tree
}
