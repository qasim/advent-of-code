import Foundation
import Utility

// MARK: - Input

var initialGrid = [Point: State]()

mainInput
    .components(separatedBy: "\n")
    .enumerated()
    .forEach { y, row in
        row
            .enumerated()
            .forEach { x, state in
                let coordinates: [Int] = {
                    // Remove trailing zeroes
                    switch (x, y) {
                    case (0, 0): return []
                    case (_, 0): return [x]
                    default:     return [x, y]
                    }
                }()

                initialGrid[Point(coordinates: coordinates)] = State(rawValue: state)
            }
    }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var grid = initialGrid

    for _ in 1...6 {
        grid = grid.runCycle(dimension: 3)
    }

    return grid.values.filter { $0 == .active }.count
}

func part2() -> Any? {
    var grid = initialGrid

    for _ in 1...6 {
        grid = grid.runCycle(dimension: 4)
    }

    return grid.values.filter { $0 == .active }.count
}

// MARK: - Types

enum State: Character {
    case active = "#"
    case inactive = "."
}

struct Point: Hashable {
    let coordinates: [Int]

    func neighbours(dimension: Int) -> [Point] {
        [-1, 0, 1]
            .permutationsWithRepetition(taking: dimension)
            .filter { (permutation: [Int]) in
                permutation != Array(repeating: 0, count: dimension)
            }
            .map { deltas -> Point in
                Point(
                    coordinates: {
                        var neighbouringCoordinates = deltas
                            .enumerated()
                            .map { index, delta -> Int in
                                guard index < coordinates.endIndex else {
                                    // Assume out of bounds dimension to be zero
                                    return delta
                                }

                                return coordinates[index] + delta
                            }

                        if neighbouringCoordinates.endIndex < coordinates.endIndex {
                            // Add back unchanged coordinates
                            neighbouringCoordinates.append(
                                contentsOf: coordinates[neighbouringCoordinates.endIndex...])
                        }

                        // Remove trailing zeroes
                        while neighbouringCoordinates.last == 0 {
                            neighbouringCoordinates.removeLast()
                        }

                        return neighbouringCoordinates
                    }()
                )
            }
    }
}

extension Dictionary where Key == Point, Value == State {
    func runCycle(dimension: Int) -> [Point: State] {
        var grid = self

        // Add any missing states for neighbours of existing points
        for point in keys {
            for neighbour in point.neighbours(dimension: dimension) {
                if self[neighbour] == nil {
                    grid[neighbour] = .inactive
                }
            }
        }

        for (point, state) in grid {
            let numberOfActiveNeighbouringStates = point
                .neighbours(dimension: dimension)
                .filter { self[$0] == .active }
                .count

            switch state {
            case .active where ![2, 3].contains(numberOfActiveNeighbouringStates):
                grid[point] = .inactive

            case .inactive where numberOfActiveNeighbouringStates == 3:
                grid[point] = .active

            default:
                continue
            }
        }

        return grid
    }
}
