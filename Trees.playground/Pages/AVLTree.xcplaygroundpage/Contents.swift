public class AVLNode<Element> {
    
    public var value: Element
    public var height = 0
    public var leftChild: AVLNode?
    public var rightChild: AVLNode?
    
    public var balanceFactor: Int {
        leftHeight - rightHeight
    }
    
    public var leftHeight: Int {
        leftChild?.height ?? -1
    }
    
    public var rightHeight: Int {
        rightChild?.height ?? -1
    }
    
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
    
    // O(n) - not a balanced tree, O(log(n)) if balanced
    var min: AVLNode {
        leftChild?.min ?? self
    }
}

extension AVLNode: CustomStringConvertible {

  public var description: String {
    diagram(for: self)
  }
  
  private func diagram(for node: AVLNode?,
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

// O(n) - not a balanced tree
func height<T>(of node: AVLNode<T>?) -> Int {
    guard let node = node else { return -1 }
    return 1 + max(height(of: node.leftChild), height(of: node.rightChild))
}

public struct AVLTree<Element: Comparable> {
    
    public private(set) var root: AVLNode<Element>?
    
    public init() {}
    
    // O(n) - not a balanced tree
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    // O(n) - not a balanced tree
    private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {
        guard let node = node else { return AVLNode(value: value) } // recursive function base case
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
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
    private mutating func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
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
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }
}

extension AVLTree: CustomStringConvertible {

  public var description: String {
    guard let root = root else { return "empty tree" }
    return String(describing: root)
  }
}

extension AVLTree {
    private func leftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        let newSubRoot = node.rightChild!
        node.rightChild = newSubRoot.leftChild
        newSubRoot.leftChild = node
        
        node.height = max(node.leftHeight, node.rightHeight) + 1
        newSubRoot.height = max(newSubRoot.leftHeight, newSubRoot.rightHeight) + 1
        return newSubRoot
    }
    
    private func rightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        let newSubRoot = node.leftChild!
        node.leftChild = newSubRoot.rightChild
        newSubRoot.rightChild = node
        
        node.height = max(node.leftHeight, node.rightHeight) + 1
        newSubRoot.height = max(newSubRoot.leftHeight, newSubRoot.rightHeight) + 1
        return newSubRoot
    }
    
    private func rightLeftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        guard let rightChild = node.rightChild else { return node }
        node.rightChild = rightRotate(rightChild)
        return leftRotate(node)
    }
    
    private func leftRightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        guard let leftChild = node.leftChild else { return node }
        node.leftChild = leftRotate(leftChild)
        return rightRotate(node)
    }
    
    private func balanced(_ node: AVLNode<Element>) -> AVLNode<Element> {
        switch node.balanceFactor {
        case 2:
            if let leftChild = node.leftChild, leftChild.balanceFactor == -1 {
                return leftRightRotate(node)
            } else {
                return rightRotate(node)
            }
        case -2:
            if let rightChild = node.rightChild, rightChild.balanceFactor == 1 {
                return rightLeftRotate(node)
            } else {
                return leftRotate(node)
            }
        default:
            return node
        }
    }
}
