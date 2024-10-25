// note - choosing a bad pivot will make the sorting be O(n^2)

// inefficient - high space complexity
public func naiveQuicksort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else { return array }
    
    let pivot = array[array.count / 2]
    let less = array.filter { $0 < pivot }
    let equal = array.filter { $0 == pivot }
    let greater = array.filter { $0 > pivot }
    
    return naiveQuicksort(less) + equal + naiveQuicksort(greater)
}

// pivot - last element
public func lomutoPartition<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let pivot = array[high]
    
    var i = low
    for j in low..<high {
        if array[j] <= pivot {
            array.swapAt(i, j)
            i += 1
        }
    }
    
    array.swapAt(i, high)
    return i
}

public func lomutoQuicksort<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let pivot = lomutoPartition(&array, low: low, high: high)
        lomutoQuicksort(&array, low: low, high: pivot - 1)
        lomutoQuicksort(&array, low: pivot + 1, high: high)
    }
}

// pivot - first element
public func hoarePartition<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let pivot = array[low]
    var i = low - 1
    var j = high + 1
    
    while true {
        repeat { j -= 1 } while array[j] > pivot
        repeat { i += 1 } while array[i] < pivot
        
        if i < j {
            array.swapAt(i, j)
        } else {
            return j
        }
    }
}

public func hoareQuicksort<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let p = hoarePartition(&array, low: low, high: high)
        hoareQuicksort(&array, low: low, high: p)
        hoareQuicksort(&array, low: p + 1, high: high)
    }
}

// trying to choose a better pivot
public func mediamOfThree<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let center = (low + high) / 2
    if array[low] > array[center] {
        array.swapAt(low, center)
    }
    
    if array[low] > array[high] {
        array.swapAt(low, high)
    }
    
    if array[center] > array[high] {
        array.swapAt(center, high)
    }
    
    return center
}

public func medianQuicksort<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = mediamOfThree(&array, low: low, high: high)
        array.swapAt(pivotIndex, high)
        
        let pivot = lomutoPartition(&array, low: low, high: high)
        lomutoQuicksort(&array, low: low, high: pivot - 1)
        lomutoQuicksort(&array, low: pivot + 1, high: high)
    }
}

// handling duplicates better
public func partitionDutchFlag<T: Comparable>(_ array: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
    let pivot = array[pivotIndex]
    var smaller = low
    var equal = low
    var larger = high
    while equal <= larger {
        if array[equal] < pivot {
            array.swapAt(smaller, equal)
            smaller += 1
            equal += 1
        } else if array[equal] == pivot {
            equal += 1
        } else {
            array.swapAt(equal, larger)
            larger -= 1
        }
    }
    return (smaller, larger)
}

public func dutchFlagQuicksort<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let (middleFirst, middleLast) = partitionDutchFlag(&array, low: low, high: high, pivotIndex: high)
        dutchFlagQuicksort(&array, low: low, high: middleFirst - 1)
        dutchFlagQuicksort(&array, low: middleLast + 1, high: high)
    }
}
