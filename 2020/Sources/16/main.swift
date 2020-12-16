import Foundation
import Utility

// MARK: - Input

let sections = mainInput.components(separatedBy: "\n\n")

let fields = sections[0]
    .components(separatedBy: "\n")
    .map { $0.components(separatedBy: ": ") }
    .map { field in
        Field(
            name: field[0],
            rules: field[1]
                .components(separatedBy: " or ")
                .map { $0.components(separatedBy: "-").compactMap(Int.init) }
                .map { $0[0]...$0[1] }
        )
    }

let allRules = fields.map(\.rules).flatMap { $0 }

let myTicket = Ticket(
    values: sections[1]
        .components(separatedBy: "\n")[1]
        .components(separatedBy: ",")
        .compactMap(Int.init)
)

let nearbyTickets = sections[2]
    .components(separatedBy: "\n")[1...]
    .map { $0.components(separatedBy: ",").compactMap(Int.init) }
    .map { Ticket(values: $0) }

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    return nearbyTickets
        .map(\.values)
        .flatMap { $0 }
        .filter { value in
            // There exists a rule for which this value is valid
            !allRules.contains { rule in
                rule.contains(value)
            }
        }
        .sum
}

func part2() -> Any? {
    let validTickets = nearbyTickets
        .filter { ticket in
            // There exists a rule for which every value in this ticket is valid
            ticket.values.allSatisfy { value in
                allRules.contains { rule in
                    rule.contains(value)
                }
            }
        }

    let possiblePositions = 0..<myTicket.values.count

    let possibleFieldsAt = possiblePositions
        .map { position in
            validTickets.map { $0.values[position] }
        }
        .map { values in
            fields.filter { field in
                // Every value passes any rule in this field
                values.allSatisfy { value in
                    field.rules.contains { rule in
                        rule.contains(value)
                    }
                }
            }
        }
        .enumerated()
        .reduce(into: [Int: [Field]]()) { accumulation, next in
            accumulation[next.offset] = next.element
        }

    // Search for concrete positions in order of most certainty to least certainty
    let orderedPositions = possibleFieldsAt.keys.sorted { possibleFieldsAt[$0]!.count < possibleFieldsAt[$1]!.count }

    var positionFor = [Field: Int]()

    for position in orderedPositions {
        let field = possibleFieldsAt[position]!.first { !positionFor.keys.contains($0) }!
        positionFor[field] = position
    }

    return positionFor
        .filter { field, _ in
            field.name.starts(with: "departure")
        }
        .map { _, position in
            myTicket.values[position]
        }
        .product
}

// MARK: - Types

struct Field: Hashable {
    let name: String
    let rules: [ClosedRange<Int>]
}

struct Ticket {
    let values: [Int]
}
