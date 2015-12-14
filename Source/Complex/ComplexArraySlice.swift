// Copyright © 2015 Venture Media Labs.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public class ComplexArraySlice: MutableLinearType  {
    public typealias Index = Int
    public typealias Element = Complex
    public typealias Slice = ComplexArraySlice
    
    var base: ComplexArray
    
    public var startIndex: Index
    public var endIndex: Index
    public var step: Index
    
    public var pointer: UnsafePointer<Element> {
        return base.pointer
    }
    
    public var mutablePointer: UnsafeMutablePointer<Element> {
        return base.mutablePointer
    }
    
    public var reals: ComplexArrayRealSlice {
        get {
            return ComplexArrayRealSlice(base: base, startIndex: startIndex, endIndex: 2*endIndex - 1, step: 2)
        }
        set {
            precondition(newValue.count == reals.count)
            for var i = 0; i < newValue.count; i += 1 {
                self.reals[i] = newValue[i]
            }
        }
    }
    
    public var imags: ComplexArrayRealSlice {
        get {
            return ComplexArrayRealSlice(base: base, startIndex: startIndex + 1, endIndex: 2*endIndex, step: 2)
        }
        set {
            precondition(newValue.count == imags.count)
            for var i = 0; i < newValue.count; i += 1 {
                self.imags[i] = newValue[i]
            }
        }
    }
    
    public required init(base: ComplexArray, startIndex: Index, endIndex: Index, step: Int) {
        assert(base.startIndex <= startIndex && endIndex <= base.endIndex)
        self.base = base
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.step = step
    }
    
    public subscript(index: Index) -> Element {
        get {
            precondition(0 <= index && index < count)
            return pointer[index]
        }
        set {
            precondition(0 <= index && index < count)
            mutablePointer[index] = newValue
        }
    }
    
    public subscript(indices: [Int]) -> Element {
        get {
            assert(indices.count == 1)
            return self[indices[0]]
        }
        set {
            assert(indices.count == 1)
            self[indices[0]] = newValue
        }
    }
    
    public subscript(intervals: [IntervalType]) -> Slice {
        get {
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            return Slice(base: base, startIndex: start, endIndex: end, step: step)
        }
        set {
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            assert(startIndex <= start && end <= endIndex)
            for i in start..<end {
                self[i] = newValue[i - start]
            }
        }
    }
}

// MARK: - Equatable

public func ==(lhs: ComplexArraySlice, rhs: ComplexArraySlice) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    
    for i in lhs.startIndex..<lhs.endIndex {
        if lhs[i] != rhs[i] {
            return false
        }
    }
    return true
}

public func ==(lhs: ComplexArraySlice, rhs: ComplexArray) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    
    for i in 0..<lhs.count {
        if lhs[i] != rhs[i] {
            return false
        }
    }
    return true
}
