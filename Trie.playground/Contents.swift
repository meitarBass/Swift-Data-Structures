public class TrieNode<Key: Hashable> {
    
    public var key: Key?
    public weak var parent: TrieNode?
    public var children: [Key: TrieNode] = [:]
    public var isTerminating = false
    public init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}

public class Trie<CollectionType: Collection> where CollectionType.Element: Hashable {
    
    public typealias Node = TrieNode<CollectionType.Element>
    private let root = Node(key: nil, parent: nil)
    
    public init() {}
    
    // O(k)
    public func insert(_ collection: CollectionType) {
        var current = root
        for element in collection {
            if current.children[element] == nil {
                current.children[element] = Node(key: element, parent: current)
            }
            current = current.children[element]!
        }
        current.isTerminating = true
    }
    
    // O(k)
    public func contains(_ collection: CollectionType) -> Bool {
        var current = root
        for element in collection {
            guard let child = current.children[element] else { return false }
            current = child
        }
        return current.isTerminating
    }
    
    // O(k)
    public func remove(_ collection: CollectionType) -> Bool {
        var current = root
        for element in collection {
            guard let child = current.children[element] else { return false } // cant find the element
            current = child
        }
        
        guard current.isTerminating else { return false} // element not in the trie
        current.isTerminating = false
        // make sure it has no children, need to check parents aren't terminating (belong to another word)
        // also we delete by making the current child of parent = nil
        while let parent = current.parent, current.children.isEmpty && !current.isTerminating {
            parent.children[current.key!] = nil
            current = parent
        }
        return true
    }
}

public extension Trie where CollectionType: RangeReplaceableCollection {
    // O(k*m) where k is the longest word, m is the number of words with that prefix
    func collections(startingWith prefix: CollectionType) -> [CollectionType] {
        var current = root
        // find the prefix
        for element in prefix {
            guard let child = current.children[element] else { return [] }
            current = child
        }
        return collections(startingWith: prefix, after: current)
    }
    
    // O(k*m) where k is the longest word, m is the number of words with that prefix
    private func collections(startingWith prefix: CollectionType, after node: Node) -> [CollectionType] {
        var results: [CollectionType] = []
        
        // prefix is word - here we add in the recursion
        if node.isTerminating { results.append(prefix) }
        
        for child in node.children.values {
            var prefix = prefix
            prefix.append(child.key!) // this is why we need RangeReplaceableCollection
            results.append(contentsOf: collections(startingWith: prefix, after: child))
        }
        
        return results
    }
}

let trie = Trie<String>()
trie.insert("car")
trie.insert("card")
trie.insert("care")
trie.insert("cared")
trie.insert("cars")
trie.insert("carbs")
trie.insert("carapace")
trie.insert("cargo")

let prefixWithCar = trie.collections(startingWith: "car")
print(prefixWithCar)

let prefixedWithCare = trie.collections(startingWith: "care")
print(prefixedWithCare)
