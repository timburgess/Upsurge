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

import Foundation

public struct QuadraticReference<Element> : QuadraticType {
    /// The arrangement of rows and columns
    public var arragement: QuadraticArrangement

    /// The pointer to the beginning of the memory block
    public var pointer: UnsafePointer<Element>

    /// The number of rows
    public var rows: Int

    /// The number of columns
    public var columns: Int

    /// The step size between major-axis elements
    public var stride: Int
}

public struct MutableQuadraticReference<Element> : MutableQuadraticType {
    /// The arrangement of rows and columns
    public var arragement: QuadraticArrangement

    /// The pointer to the beginning of the memory block
    public var pointer: UnsafePointer<Element> {
        return UnsafePointer<Element>(mutablePointer)
    }

    /// The mutable pointer to the beginning of the memory block
    public var mutablePointer: UnsafeMutablePointer<Element>

    /// The number of rows
    public var rows: Int

    /// The number of columns
    public var columns: Int

    /// The step size between major-axis elements
    public var stride: Int
}


public extension QuadraticType {
    public func rowReference(index: Int) -> LinearReference<Element> {
        if arragement == .RowMajor {
            return LinearReference<Element>(pointer: pointer + index * stride, endIndex: columns, step: 1)
        } else {
            return LinearReference<Element>(pointer: pointer + index, endIndex: stride * (columns - 1) + 1, step: stride)
        }
    }

    public func columnReference(index: Int) -> LinearReference<Element> {
        if arragement == .ColumnMajor {
            return LinearReference<Element>(pointer: pointer + index * stride, endIndex: rows, step: 1)
        } else {
            return LinearReference<Element>(pointer: pointer + index, endIndex: stride * (rows - 1) + 1, step: stride)
        }
    }
}


public extension MutableQuadraticType {
    public func rowReference(index: Int) -> MutableLinearReference<Element> {
        if arragement == .RowMajor {
            return MutableLinearReference<Element>(mutablePointer: mutablePointer + index * stride, endIndex: columns, step: 1)
        } else {
            return MutableLinearReference<Element>(mutablePointer: mutablePointer + index, endIndex: stride * (columns - 1) + 1, step: stride)
        }
    }

    public func columnReference(index: Int) -> MutableLinearReference<Element> {
        if arragement == .ColumnMajor {
            return MutableLinearReference<Element>(mutablePointer: mutablePointer + index * stride, endIndex: rows, step: 1)
        } else {
            return MutableLinearReference<Element>(mutablePointer: mutablePointer + index, endIndex: stride * (rows - 1) + 1, step: stride)
        }
    }
}
