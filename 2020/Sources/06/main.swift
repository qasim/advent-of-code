import Foundation

// MARK: - Main

let groups = mainInput
    .components(separatedBy: "\n\n")
    .map { group in
        Group(
            people: group
                .components(separatedBy: "\n")
                .map { Person(answers: $0) }
        )
    }

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    groups
        .map { group in
            group.uniqueAnswers.count
        }
        .reduce(0, +)
}

func part2() -> Any? {
    groups
        .map { group in
            group.unanimousAnswers.count
        }
        .reduce(0, +)
}

// MARK: - Types

struct Group {
    let people: [Person]

    var uniqueAnswers: Set<Character> {
        people
            .map(\.answers)
            .reduce(Set<Character>()) { accumulation, next in
                accumulation.union(next)
            }
    }

    var unanimousAnswers: Set<Character> {
        guard let firstPersonAnswers = people.first?.answers else {
            return Set<Character>()
        }

        return people
            .dropFirst()
            .map(\.answers)
            .reduce(Set(firstPersonAnswers)) { accumulation, next in
                accumulation.intersection(next)
            }
    }
}

struct Person {
    let answers: String
}
