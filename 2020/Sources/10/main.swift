import Foundation
import Utility

// MARK: - Input

var adapters = mainInput
    .components(separatedBy: "\n")
    .compactMap(Int.init)
    .sorted()

// Append the device's built-in adapter
adapters.append(adapters.last! + 3)

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    let differences = adapters.differences
    return differences.filter { $0 == 1 }.count * differences.filter { $0 == 3 }.count
}

func part2() -> Any? {
    adapters
        .consecutiveCounts(of: 1)
        .map { count in
            switch count {
            case 1: return 1
            case 2: return 2
            case 3: return 4
            case 4: return 7

            default:
                // This pattern looks like second differences, but the
                // official test input never gets more complicated than
                // 4 consecutive single-difference adapters, so I don't
                // bother either.
                fatalError("Implement first differences")
            }
        }
        .product
}

// MARK: - Types

extension Array where Element == Int {
    var differences: [Int] {
        self[1...]
            .reduce([self[0]]) { accumulation, next in
                accumulation + [next - self[accumulation.endIndex - 1]]
            }
    }

    func consecutiveCounts(of element: Int) -> [Int] {
        differences
            .split(whereSeparator: { $0 != element })
            .map(\.count)
    }
}
