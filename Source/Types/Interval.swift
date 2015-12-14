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

public protocol IntervalType {
    var start: Int? { get }
    var end: Int? { get }
}

public enum Interval: IntervalType, IntegerLiteralConvertible {
    case All
    case Range(Swift.Range<Int>)
    
    public init(range: Swift.Range<Int>) {
        self = Interval.Range(range)
    }
    
    public init(integerLiteral value: Int) {
        self = Interval.Range(value...value)
    }

    public var start: Int? {
        switch self {
        case .All: return nil
        case .Range(let range): return range.startIndex
        }
    }

    public var end: Int? {
        switch self {
        case .All: return nil
        case .Range(let range): return range.endIndex
        }
    }
}

extension Range: IntervalType {
    public var start: Int? {
        return startIndex as? Int
    }

    public var end: Int? {
        return endIndex as? Int
    }
}
