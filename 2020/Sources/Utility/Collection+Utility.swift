import Foundation

extension Collection where Element: Comparable {
    public func numberOfOccurences(of element: Element) -> Int {
        split(omittingEmptySubsequences: false, whereSeparator: { $0 == element }).count - 1
    }
}

extension Collection {
    public func permutationsWithRepetition(taking: Int) -> [[Element]] {
        guard count >= 0 && taking > 0 else {
            return [[]]
        }

        if taking == 1 {
            return map { [$0] }
        }

        var permutations = [[Element]]()

        for element in self {
            permutations += permutationsWithRepetition(taking: taking - 1).map { [element] + $0 }
        }

        return permutations
    }
}
