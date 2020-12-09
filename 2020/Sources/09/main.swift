import Foundation

// MARK: - Main

let numbers = mainInput
    .components(separatedBy: "\n")
    .compactMap(Int.init)

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    numbers.firstExceptionOfXMAS(preamble: 25)
}

func part2() -> Any? {
    let contiguousSlice = numbers.contiguousSlice(of: numbers.firstExceptionOfXMAS(preamble: 25))

    guard let min = contiguousSlice.min(), let max = contiguousSlice.max() else {
        return nil
    }

    return min + max
}

// MARK: - Types

extension Array where Element == Int {
    func firstExceptionOfXMAS(preamble: Int) -> Int {
        var preambleSlice = self[0...preamble - 1]

        for number in self[preamble...endIndex - 1] {
            if !preambleSlice.containsSum(of: number) {
                return number
            } else {
                preambleSlice = self[preambleSlice.startIndex + 1...preambleSlice.endIndex]
            }
        }

        return 0
    }

    func contiguousSlice(of number: Int) -> ArraySlice<Int> {
        var start = 0
        var size = 0

        while start < endIndex {
            let slice = self[start...start + size]
            switch slice.reduce(0, +) {
            case ..<number:
                size += 1

            case number:
                return slice

            default:
                start += 1
                size = 0
            }
        }

        return []
    }
}

extension ArraySlice where Element == Int {
    func containsSum(of number: Int) -> Bool {
        for x in self {
            for y in self {
                if x + y == number {
                    return true
                }
            }
        }
        return false
    }
}
