public class TrieNode<Key: Hashable> {
    
    public var key: Key?
    public weak var parent: TrieNode?
    public var children: [Key: TrieNode] = [:]
    public init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}


public class Trie<CollectionType: Collection> where CollectionType.Element: Hashable {
    
    public typealias Node = TrieNode<CollectionType.Element>
    private let root = Node(key: nil, parent: nil)
    
    public init() {}
}
