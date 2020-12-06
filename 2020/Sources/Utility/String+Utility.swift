import Foundation

extension String {
    public subscript(index: Int) -> Character {
        let characterIndex = self.index(startIndex, offsetBy: index)
        return self[characterIndex]
    }

    public subscript(range: Range<Int>) -> Substring {
        let startIndex = index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
}
