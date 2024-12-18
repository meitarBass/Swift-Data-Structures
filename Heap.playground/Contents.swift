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
            siftDown(from: 0, upTo: elements.count)
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
                siftDown(from: index, upTo: elements.count)
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
                siftDown(from: i, upTo: elements.count)
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


extension Heap {
    mutating func siftDown(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            
            var candidate = parent
            if left < size && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            
            if right < size && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            
            if candidate == parent {
                return
            }
            
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    // heap sort - O(nlog(n))
    func sorted() -> [Element] {
        var heap = Heap(sort: sort, elements: elements)
        
        for index in heap.elements.indices.reversed() {
            heap.elements.swapAt(0, index)
            heap.siftDown(from: 0, upTo: index)
        }
        return heap.elements
    }
}

let heap = Heap(sort: >, elements: [6,12,2,26,8,18,21,9,5])
print(heap.sorted())
