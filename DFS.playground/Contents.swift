extension Graph where Element: Hashable {
    
    func depthFirstSearch(from source: Vertex<Element>) -> [Vertex<Element>] {
        var stack: Stack<Vertex<Element>> = []
        var pushed: Set<Vertex<Element>> = []
        var visited: [Vertex<Element>] = []
        
        stack.push(source)
        pushed.insert(source)
        visited.append(source)
        
        outer: while let vertex = stack.peek() {
            let neighbors = edges(from: vertex)
            guard !neighbors.isEmpty else {
                stack.pop()
                continue
            }
            
            for edge in neighbors {
                if !pushed.contains(edge.destination) {
                    stack.push(edge.destination)
                    pushed.insert(edge.destination)
                    visited.append(edge.destination)
                    continue outer
                }
            }
            stack.pop()
        }
        
        return visited
    }
}

extension Graph where Element: Hashable {
    
    public func hasCycle(from source: Vertex<Element>) -> Bool {
        var pushed: Set<Vertex<Element>> = []
        return hasCycle(from: source, pushed: &pushed)
    }
    
    private func hasCycle(from source: Vertex<Element>, pushed: inout Set<Vertex<Element>>) -> Bool {
        pushed.insert(source)
        let neighbors = edges(from: source)
        for edge in neighbors {
            if !pushed.contains(edge.destination) && hasCycle(from: edge.destination, pushed: &pushed) {
                return true
            } else if pushed.contains(edge.destination) {
                return true
            }
        }
        pushed.remove(source)
        return false
    }
}


let graph = AdjacencyList<String>()
let a = graph.createVertex(data: "A")
let b = graph.createVertex(data: "B")
let c = graph.createVertex(data: "C")
let d = graph.createVertex(data: "D")
let e = graph.createVertex(data: "E")
let f = graph.createVertex(data: "F")
let g = graph.createVertex(data: "G")
let h = graph.createVertex(data: "H")

graph.add(.directed, from: a, to: b, weight: nil)
graph.add(.directed, from: a, to: c, weight: nil)
graph.add(.directed, from: a, to: d, weight: nil)
graph.add(.directed, from: b, to: e, weight: nil)
graph.add(.directed, from: b, to: a, weight: nil)
graph.add(.directed, from: c, to: g, weight: nil)
graph.add(.directed, from: e, to: f, weight: nil)
graph.add(.directed, from: e, to: h, weight: nil)
graph.add(.directed, from: f, to: g, weight: nil)
graph.add(.directed, from: f, to: c, weight: nil)

let vertices = graph.depthFirstSearch(from: a)
vertices.forEach { vertex in
    print(vertex)
}

print(graph.hasCycle(from: a))
