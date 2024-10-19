// @discardableResult - result can be ignored
// defer - this piece of code will run last in the function
// n - number of elements in the list

class Node<Value> {

    public var value: Value
    public var nextNode: Node?
    
    public init(value: Value, nextNode: Node? = nil) {
        self.value = value
        self.nextNode = nextNode
    }
}

// for printing purposes
extension Node: CustomStringConvertible {
    
    // O(n)
    public var description: String {
        guard let nextNode = nextNode else { return "\(value)" } // last node case
        return "\(value) -> " + String(describing: nextNode) + " "
    }
}

struct LinkedList<Value> {
    
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    // O(n)
    public init(list: LinkedList) {
        guard var oldNode = list.head else { return }
        head = Node(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.nextNode {
            newNode!.nextNode = Node(value: nextOldNode.value)
            newNode = newNode!.nextNode
            
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
    // O(1)
    public var isEmpty: Bool {
        head == nil
    }
    
    // O(1)
    public mutating func push(_ value: Value) {
        head = Node(value: value, nextNode: head)
        if tail == nil {
            tail = head
        }
    }
    
    // O(1)
    public mutating func push(_ node: Node<Value>) {
        head = node
        if tail == nil {
            tail = head
        }
    }
    
    // O(1)
    public mutating func append(_ value: Value) {
        guard !isEmpty else {
            // it is an empty list
            push(value)
            return
        }
        // we know there is a tail for sure
        tail!.nextNode = Node(value: value)
        tail = tail!.nextNode
    }
    
    // O(1)
    public mutating func append(_ node: Node<Value>) {
        guard !isEmpty else {
            push(node)
            return
        }
        tail!.nextNode = node
        tail = tail!.nextNode
    }
    
    // O(1)
    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        if tail === node {
            append(value)
            return tail!
        }
        
        node.nextNode = Node(value: value, nextNode: node.nextNode)
        return node.nextNode! // we know for sure there is a next node, we just created it
    }
    
    // O(n)
    @discardableResult
    public func getNode(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode?.nextNode
            currentIndex += 1
        }
        
        return currentNode
    }
    
    // O(1)
    @discardableResult
    public mutating func pop() -> Value? {
        // update the list only after returning
        defer {
            head = head?.nextNode
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    // O(n)
    @discardableResult
    public mutating func removeLast() -> Value? {
        guard let head = head else { return nil } // empty list
        guard head.nextNode != nil else { return pop() } // only 1 item in list
        
        var prev = head
        var current = head
        
        while current.nextNode != nil {
            // current will finish at tail
            // prev will be prev to tail
            prev = current
            current = (current.nextNode)!
        }
        
        prev.nextNode = nil
        tail = prev
        return current.value
    }
    
    // O(1)
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            if node.nextNode === tail {
                tail = node
            }
            node.nextNode = node.nextNode?.nextNode
        }
        return node.nextNode?.value
    }
}

extension LinkedList: CustomStringConvertible {
    // O(n)
    public var description: String {
        guard let head else { return "Empty List" }
        return head.description
    }
}
