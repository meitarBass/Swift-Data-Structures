// using an array instead of a binary tree makes it easier to use indexes and such
// need to remember that adding a new element to the array might change the array which
// is an expensive operation (O(n))

struct Heap<Element: Equatable> {
    
    var elements: [Element] = []
    let sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        
        buildHeap()
    }
    
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var count: Int {
        elements.count
    }
    
    func peek() -> Element? {
        elements.first
    }
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        (index - 1) / 2
    }
    
    mutating func remove() -> Element? {
        guard !isEmpty else { return nil }
        elements.swapAt(0, count - 1)
        defer {
            siftDown(from: 0)
        }
        return elements.removeLast()
    }
    
    mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            
            var candidate = parent
            if left < count && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < count && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent { return }
            
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    // depend if the array gonna resize or not, but amoretized time is O(1)
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }
    
    // O(log(n))
    mutating func siftUp(from index: Int) {
        var child = index
        var parent = parentIndex(ofChildAt: child)
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(ofChildAt: child)
        }
    }
    
    // O(log(n))
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else { return nil } // out of array bounds
        if index == elements.count - 1 { return elements.removeLast() }
        else {
            elements.swapAt(index, elements.count - 1)
            defer {
                // only 1 of the operations could work, so we try both and the correct one will be executed
                siftDown(from: index)
                siftUp(from: index)
            }
            return elements.removeLast()
        }
    }
    
    // O(n) - might have to check all children
    func getIndex(of element: Element, startingAt i: Int) -> Int? {
        if i >= count { return nil } // out of array bounds
        if sort(element, elements[i]) { return nil }
        if element == elements[i] { return i }
        if let j = getIndex(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j
        }
        
        if let j = getIndex(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j
        }
        return nil
    }
    
    private mutating func buildHeap() {
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i)
            }
        }
    }
    
    mutating public func merge(_ heap: Heap) {
        elements = elements + heap.elements
        buildHeap()
    }
}


func getNthSmallestElement(in array: [Int], n: Int) -> Int? {
    var heap = Heap(sort: <, elements: array)
    var elementsChecked = 1
    while !heap.isEmpty {
        let element = heap.remove()
        if elementsChecked == n {
            return element
        }
        elementsChecked += 1
    }
    return nil
}

public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

/* BEGINNING OF THE PRIORITY QUEUE IMPLEMENTATION */

struct PriorityQueue<Element: Equatable>: Queue {
    
    private var heap: Heap<Element>
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        heap = Heap(sort: sort, elements: elements)
    }
    
    var isEmpty: Bool {
        heap.isEmpty
    }
    
    var peek: Element? {
        heap.peek()
    }
    
    mutating func enqueue(_ element: Element) -> Bool {
        heap.insert(element)
        return true
    }
    
    mutating func dequeue() -> Element? {
        heap.remove()
    }
}
