public func bubbleSort<Element>(_ array: inout [Element]) where Element: Comparable {
    guard array.count >= 2 else { return }
    for end in (1 ..< array.count).reversed() {
        var swapped = false
        for current in 0 ..< end {
            if array[current] > array[current + 1] {
                array.swapAt(current, current + 1)
                swapped = true
            }
        }
        if !swapped { return }
    }
}

public func selectionSort<Element>(_ array: inout [Element]) where Element: Comparable {
    guard array.count >= 2 else { return }
    for current in 0 ..< (array.count - 1) {
        var lowest = current
        for other in (current + 1) ..< array.count {
            if array[lowest] > array[other] {
                lowest = other
            }
        }
        
        if lowest != current { array.swapAt(lowest, current) }
    }
}
