import Foundation

let input = try! String(contentsOfFile: "input.txt")
let groups = input
    .components(separatedBy: "\r\n\r\n")
    .map { group in
        Group(
            people: group
                .components(separatedBy: "\r\n")
                .map { Person(answers: $0) })
    }

print("Part 1: \(part1(groups))")
print("Part 2: \(part2(groups))")

func part1(_ groups: [Group]) -> Int {
    groups
    .map { group in
        group.uniqueAnswers.count
    }
    .reduce(0, +)
}

func part2(_ groups: [Group]) -> Int {
    groups
    .map { group in
        group.unanimousAnswers.count
    }
    .reduce(0, +)
}

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
