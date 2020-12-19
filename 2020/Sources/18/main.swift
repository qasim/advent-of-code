import Foundation
import Regex
import Utility

// MARK: - Input

let expressions = mainInput
    .replacingOccurrences(of: " ", with: "")
    .components(separatedBy: "\n")

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    expressions
        .map { $0.solve(withPrecedence: false) }
        .sum
}

func part2() -> Any? {
    expressions
        .map { $0.solve(withPrecedence: true) }
        .sum
}

// MARK: - Types

struct Re {
    static let subExpressions = Regex(#"\(\d+([+|*]\d+)+\)"#)
    static let valuesAndOperations = Regex(#"\d+|[+*]"#)
    static let additions = Regex(#"\d+\+\d+"#)
}

extension String {
    func solve(withPrecedence: Bool) -> Int {
        // Solve sub-expressions first
        var expression = self.solveSubExpressions(withPrecedence: withPrecedence)

        if withPrecedence {
            // Solve additions first
            while let match = Re.additions.firstMatch(in: expression) {
                expression.replaceSubrange(match.range, with: String(match.matchedString.solution))
            }
        }

        return expression.solution
    }

    func solveSubExpressions(withPrecedence: Bool) -> String {
        var expression = self

        while let match = Re.subExpressions.firstMatch(in: expression) {
            let subExpression = String(match.matchedString.dropFirst().dropLast())
            expression.replaceSubrange(match.range, with: String(subExpression.solve(withPrecedence: withPrecedence)))
        }

        return expression
    }

    var solution: Int {
        let tokens = Re.valuesAndOperations.allMatches(in: self).map(\.matchedString)

        var result = Int(tokens[0])!

        for index in stride(from: 1, to: tokens.endIndex, by: 2) {
            switch tokens[index] {
            case "+": result += Int(tokens[index + 1])!
            case "*": result *= Int(tokens[index + 1])!
            default:  fatalError("Unsupported operator")
            }
        }

        return result
    }
}
