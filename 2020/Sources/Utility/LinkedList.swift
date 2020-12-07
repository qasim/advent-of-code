import Foundation

public class LinkedList<T> {
    private var head: Node<T>?
    private var tail: Node<T>?

    public init() {}

    public var isEmpty: Bool {
        head == nil
    }

    public var first: Node<T>? {
        return head
    }

    public var last: Node<T>? {
        return tail
    }

    public func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }

    public func remove(node: Node<T>) -> T {
        let previous = node.previous
        let next = node.next

        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }
        next?.previous = previous

        if next == nil {
            tail = previous
        }

        node.previous = nil
        node.next = nil

        return node.value
    }

    public class Node<T> {
        var value: T
        var next: Node<T>?

        weak var previous: Node<T>?

        init(value: T) {
            self.value = value
        }
    }
}
