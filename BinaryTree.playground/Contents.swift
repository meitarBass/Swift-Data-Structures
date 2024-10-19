public class BinaryNode<Element> {
    
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    public init(value: Element) {
        self.value = value
    }
    
    // O(n)
    public func inOrder(visit: (Element) -> Void) {
        leftChild?.inOrder(visit: visit)
        visit(value)
        rightChild?.inOrder(visit: visit)
    }
    
    // O(n)
    public func preOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.preOrder(visit: visit)
        rightChild?.preOrder(visit: visit)
    }
    
    // O(n)
    public func postOrder(visit: (Element) -> Void) {
        leftChild?.postOrder(visit: visit)
        rightChild?.postOrder(visit: visit)
        visit(value)
    }
    
    // O(n) - not a balanced tree
    var min: BinaryNode {
        leftChild?.min ?? self
    }
}

extension BinaryNode: CustomStringConvertible {

  public var description: String {
    diagram(for: self)
  }
  
  private func diagram(for node: BinaryNode?,
                       _ top: String = "",
                       _ root: String = "",
                       _ bottom: String = "") -> String {
    guard let node = node else {
      return root + "nil\n"
    }
    if node.leftChild == nil && node.rightChild == nil {
      return root + "\(node.value)\n"
    }
    return diagram(for: node.rightChild,
                   top + " ", top + "┌──", top + "│ ")
         + root + "\(node.value)\n"
         + diagram(for: node.leftChild,
                   bottom + "│ ", bottom + "└──", bottom + " ")
  }
}

public struct BinarySearchTree<Element: Comparable> {
    
    public private(set) var root: BinaryNode<Element>?
    
    public init() {}
    
    // O(n) - not a balanced tree
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    // O(n) - not a balanced tree
    private func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element> {
        guard let node = node else { return BinaryNode(value: value) } // recursive function base case
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        return node
    }
    
    // O(n) - not a balanced tree
    public func contains(_ value: Element) -> Bool {
        var current = root
        while let node = current {
            if node.value == value {
                return true
            }
            
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
    
    // O(n) - not a balanced tree
    public mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
    // O(n) - not a balanced tree
    private func remove(node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>? {
        guard let node = node else { return nil}
        if value == node.value {
            // here we actually remove
            if node.leftChild == nil && node.rightChild == nil {
                // node is a leaf, we can remove safely
                return nil
            }
            
            if node.leftChild == nil {
                // node has only right child, exchange and delete it
                return node.rightChild
            }
            
            if node.rightChild == nil {
                // node has only left child, exchange and delete it
                return node.leftChild
            }
            
            // node has left and right children,
            // in order to stay balanced, exchange the node with the lowest value of the right side and delete it
            node.value = node.rightChild!.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        return node
    }
}

extension BinarySearchTree: CustomStringConvertible {

  public var description: String {
    guard let root = root else { return "empty tree" }
    return String(describing: root)
  }
}

// O(n) - not a balanced tree
func height<T>(of node: BinaryNode<T>?) -> Int {
    guard let node = node else { return -1 }
    return 1 + max(height(of: node.leftChild), height(of: node.rightChild))
}


var bst = BinarySearchTree<Int>()
bst.insert(3)
bst.insert(1)
bst.insert(4)
bst.insert(0)
bst.insert(2)
bst.insert(5)
