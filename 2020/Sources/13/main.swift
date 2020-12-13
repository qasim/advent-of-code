import Foundation

// MARK: - Input

let lines = mainInput.components(separatedBy: "\n")

let time = Int(lines[0])!
let buses = lines[1]
    .components(separatedBy: ",")
    .enumerated()
    .compactMap { index, rawBusID -> Bus? in
        guard let busID = Int(rawBusID) else {
            return nil
        }

        return Bus(id: busID, offset: index, stride: busID)
    }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    let closestBus = buses
        .sorted { $0.nextDepartureTime(after: time) < $1.nextDepartureTime(after: time) }
        .first!

    return closestBus.id * (closestBus.nextDepartureTime(after: time) - time)
}

func part2() -> Any? {
    buses[1...]
        .reduce(buses[0]) { accumulation, next in
            accumulation.merging(with: next)
        }
        .id
}

// MARK: - Types

struct Bus {
    let id: Int
    let offset: Int
    let stride: Int

    func nextDepartureTime(after time: Int) -> Int {
        Int(ceil(Double(time) / Double(id))) * id
    }

    func departsAt(_ time: Int) -> Bool {
        time.isMultiple(of: id)
    }

    func merging(with bus: Bus) -> Bus {
        var t = id

        while !bus.departsAt(t + bus.offset) {
            t += stride
        }

        return Bus(id: t, offset: offset, stride: stride * bus.id)
    }
}
