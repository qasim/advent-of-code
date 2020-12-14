import Foundation

extension String {
    public subscript(index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }

    public subscript(range: Range<Int>) -> Substring {
        let startIndex = index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
}

extension String {
    public mutating func replace(_ index: String.Index, with character: Character) {
        replaceSubrange(index...index, with: String(character))
    }

    public mutating func replace(_ index: Int, with character: Character) {
        replace(self.index(startIndex, offsetBy: index), with: character)
    }
}

