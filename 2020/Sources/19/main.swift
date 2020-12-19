import Foundation
import Regex
import Utility

let sections = mainInput.components(separatedBy: "\n\n")

func rules(isFixed: Bool) -> [Int: () -> String] {
    var rules = [Int: () -> String]()

    sections[0]
        .components(separatedBy: "\n")
        .forEach { line in
            let tokens = line.components(separatedBy: ": ")
            let ruleNumber = Int(tokens[0])!
            let rawRule = tokens[1]

            if rawRule.starts(with: "\"") {
                rules[ruleNumber] = {
                    String(rawRule[1])
                }
            }
            else if rawRule.contains(" | ") {
                rules[ruleNumber] = {
                    let pattern = rawRule
                        .components(separatedBy: " | ")
                        .map { conditions in
                            conditions
                                .components(separatedBy: " ")
                                .forceMap(Int.init)
                                .map { rules[$0]!() }
                                .joined()
                        }
                        .joined(separator: "|")

                    return "(?:\(pattern))"
                }
            }
            else {
                rules[ruleNumber] = {
                    let patterns = rawRule
                        .components(separatedBy: " ")
                        .forceMap(Int.init)
                        .map { rules[$0]!() }

                    if isFixed {
                        if ruleNumber == 8 {
                            return "(?:\(patterns[0]))+"
                        }
                        else if ruleNumber == 11 {
                            let a = patterns[0]
                            let b = patterns[1]
                            // Foundation's regular expressions do not support recursion,
                            // so we just go as deep as it takes until the number of
                            // matches stop increasing.
                            return "(?:\(a)\(b)|\(a)\(a)\(b)\(b)|\(a)\(a)\(a)\(b)\(b)\(b)|\(a)\(a)\(a)\(a)\(b)\(b)\(b)\(b))"
                        }
                    }

                    return patterns.joined()
                }
            }
        }

    return rules
}

let messages = sections[1].components(separatedBy: "\n")

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    let originalRules = rules(isFixed: false)
    let pattern = try! Regex(string: "^\(originalRules[0]!())$")

    return messages
        .filter { message in
            pattern.matches(message)
        }
        .count
}

func part2() -> Any? {
    let fixedRules = rules(isFixed: true)
    let pattern = try! Regex(string: "^\(fixedRules[0]!())$")

    return messages
        .filter { message in
            pattern.matches(message)
        }
        .count
}
