import Foundation
import Utility

// MARK: - Input

let tiles = mainInput
    .components(separatedBy: "\n\n")
    .map { $0.components(separatedBy: "\n") }
    .map { Tile(id: Int($0[0].filter(\.isNumber))!, image: Array($0[1...])) }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    tiles
        .filter { tile in
            tiles
                .filter { $0 != tile }
                .filter { tileToCompare in
                    !Set(tile.possibleBorders).isDisjoint(with: tileToCompare.possibleBorders)
                }
                .count == 2
        }
        .map(\.id)
        .product
}

// MARK: - Types

struct Point: Hashable {
    let x, y: Int
}

class Tile {
    let id: Int
    let image: [String]

    init(id: Int, image: [String]) {
        self.id = id
        self.image = image
    }

    lazy var possibleBorders: [[Character]] = {
        let borders = [
            Array(image[0]),
            Array(image[9]),
            image.map { $0[0] },
            image.map { $0[9] }
        ]

        return borders + borders.map { $0.reversed() }
    }()
}

extension Tile: Equatable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id && lhs.image == rhs.image
    }
}
