public enum EdgeType {
    
    case directed
    case undirected
    
}

public protocol Graph {
    
    associatedtype Element
    
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to detsination: Vertex<Element>, weight: Double?)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?)
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
}

// vertex implementation

public struct Vertex<T> {
    
    public let index: Int
    public let data: T
    
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    public var description: String {
        "\(index): \(data)"
    }
}

// edge implementation

public struct Edge<T> {
    
    public let source: Vertex<T>
    public let destination: Vertex<T>
    public let weight: Double?
    
}


