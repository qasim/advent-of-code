import Foundation

public struct Queue<T> {
    private var list = LinkedList<T>()

    public init() {}

    public var isEmpty: Bool {
        list.isEmpty
    }

    public mutating func enqueue(_ element: T) {
        list.append(value: element)
    }

    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else {
            return nil
        }

        return list.remove(node: element)
    }
}
