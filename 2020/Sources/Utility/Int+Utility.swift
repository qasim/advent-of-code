import Foundation

extension Int {
    public var factorial: Int {
        if self == 1 {
            return 1
        } else {
            return self * (self - 1).factorial
        }
    }
}

extension Array where Element == Int {
    public var sum: Int {
        reduce(0, +)
    }

    public var product: Int {
        reduce(1, *)
    }
}
