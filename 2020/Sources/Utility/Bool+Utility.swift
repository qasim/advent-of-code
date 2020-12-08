import Foundation

extension Bool {
    public static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
