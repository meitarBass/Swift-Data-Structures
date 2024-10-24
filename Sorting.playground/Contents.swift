// O(n^2)
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

// O(n^2)
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


// O(n^2)
public func insertionSort<Element>(_ array: inout [Element]) where Element: Comparable {
    guard array.count >= 2 else { return }
    for current in 1 ..< array.count {
        for shifting in (1...current).reversed() {
            if array[shifting] < array[shifting - 1] {
                array.swapAt(shifting, shifting - 1)
            } else {
                break
            }
        }
    }
}

//  O(n) - we have total of n elements (left + right)
// when sorting we have n*O(1) operations (choose correct element to insert now, n times)
private func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable {
    var leftIndex = 0
    var rightIndex = 0
    
    var result: [Element] = []
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        
        if leftElement < rightElement {
            result.append(leftElement)
            leftIndex += 1
        } else if leftElement > rightElement {
            result.append(rightElement)
            rightIndex += 1
        } else {
            result.append(leftElement)
            leftIndex += 1
            result.append(rightElement)
            rightIndex += 1
        }
    }
    
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    
    return result
}

// O(nlog(n)) time and space complexity
public func mergeSort<Element>(_ array: [Element]) -> [Element] where Element: Comparable {
    guard array.count > 1 else { return array }
    
    let middle = array.count / 2
    
    let left = mergeSort(Array(array[..<middle]))
    let right = mergeSort(Array(array[middle...]))
    
    return merge(left, right)
}
