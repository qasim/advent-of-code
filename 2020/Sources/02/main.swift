import Foundation
import Regex
import Utility

// MARK: - Main

let entries = Regex(#"^(\d+)-(\d+) (\w): (\w+)$"#, options: .anchorsMatchLines)
    .allMatches(in: mainInput)
    .map { match -> [String] in
        match.captures.compactMap { $0 }
    }
    .map { captures -> Entry in
        Entry(
            password: captures[3],
            policy: Policy(
                character: captures[2].first ?? "a",
                bound: Bound(
                    min: Int(captures[0]) ?? 0,
                    max: Int(captures[1]) ?? 0
                )
            )
        )
    }

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    entries.filter(\.passesSledRentalRequirements).count
}

func part2() -> Any? {
    entries.filter(\.passesTobogganCorporateRequirements).count
}

// MARK: - Types

struct Entry {
    let password: String
    let policy: Policy

    var passesSledRentalRequirements: Bool {
        (policy.bound.min...policy.bound.max)
            .contains(password.filter { $0 == policy.character }.count)
    }

    var passesTobogganCorporateRequirements: Bool {
        (password[policy.bound.min - 1] == policy.character) ^ (password[policy.bound.max - 1] == policy.character)
    }
}

struct Policy {
    let character: Character
    let bound: Bound
}

struct Bound {
    let min: Int
    let max: Int
}
