import Foundation
import Utility

// MARK: - Main

var bags: [Bag] = []
var rulesToParse: [String] = []

mainInput
    .components(separatedBy: "\n")
    .map { line -> [String] in
        line.components(separatedBy: " contain ")
    }
    .forEach { tokens in
        bags.append(Bag(name: String(tokens[0].dropLast())))
        rulesToParse.append(tokens[1])
    }

rulesToParse
    .map { rules -> [[String]] in
        if rules == "no other bags." {
            return [[]]
        } else {
            return rules
                .components(separatedBy: ", ")
                .map { rule -> String in
                    switch rule.suffix(2) {
                    case "g.", "gs": return String(rule.dropLast(1))
                    case "s.": return String(rule.dropLast(2))
                    default: return rule
                    }
                }
                .map { rule -> [String] in
                    rule
                        .split(maxSplits: 1, whereSeparator: \.isWhitespace)
                        .map(String.init)
                }
        }
    }
    .enumerated()
    .forEach { index, rules in
        bags[index].rules = rules
            .compactMap { rule in
                guard rule.count == 2 else {
                    return nil
                }

                return Rule(
                    bag: bags.first(where: { $0.name == rule[1] })!,
                    amount: Int(rule[0])!
                )
            }
    }

let shinyGoldBag = bags.first(where: { $0.name == "shiny gold bag" })!

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    bags
        .filter { bag in
            bag != shinyGoldBag && bag.eventuallyContains(shinyGoldBag)
        }
        .count
}

func part2() -> Any? {
    shinyGoldBag.numberOfContainingBags
}

// MARK: - Types

class Bag {
    let name: String
    var rules: [Rule] = []

    init(name: String) {
        self.name = name
    }

    func eventuallyContains(_ bag: Bag) -> Bool {
        var visitedBags = Set<Bag>()

        var bagsToCheck = Queue<Bag>()
        bagsToCheck.enqueue(self)

        while !bagsToCheck.isEmpty {
            guard let bagToCheck = bagsToCheck.dequeue(), !visitedBags.contains(bagToCheck) else {
                continue
            }

            if bagToCheck == bag {
                return true
            } else {
                visitedBags.insert(bagToCheck)
            }

            for childBagToCheck in bagToCheck.rules.map({ $0.bag }) {
                bagsToCheck.enqueue(childBagToCheck)
            }
        }

        return false
    }

    var numberOfContainingBags: Int {
        rules
            .map { rule in
                rule.amount + rule.amount * rule.bag.numberOfContainingBags
            }
            .reduce(0, +)
    }
}

extension Bag: Equatable, Hashable {
    static func == (lhs: Bag, rhs: Bag) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class Rule {
    let bag: Bag
    let amount: Int

    init(bag: Bag, amount: Int) {
        self.bag = bag
        self.amount = amount
    }
}
