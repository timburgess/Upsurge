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

import Accelerate

public func sum<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result = 0.0
    vDSP_sveD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func max<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_maxvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func min<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_minvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func mean<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_meanvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func meamg<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_meamgvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func measq<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_measqvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

public func rmsq<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    vDSP_rmsqvD(x.pointer + x.startIndex, x.step, &result, vDSP_Length(x.count))
    return result
}

/// Compute the standard deviation, a measure of the spread of deviation.
public func std<M: LinearType where M.Element == Double>(x: M) -> Double {
    let diff = x - mean(x)
    let variance = measq(diff)
    return sqrt(variance)
}

/**
    Perform a linear regression.

    - parameter x: Array of x-values
    - parameter y: Array of y-values
    - returns: The slope and intercept of the regression line
*/
public func linregress<MX: LinearType, MY: LinearType where MX.Element == Double, MY.Element == Double>(x: MX, _ y: MY) -> (slope: Double, intercept: Double) {
    precondition(x.count == y.count, "Vectors must have equal count")
    let meanx = mean(x)
    let meany = mean(y)
    let meanxy = mean(x * y)
    let meanx_sqr = measq(x)

    let slope = (meanx * meany - meanxy) / (meanx * meanx - meanx_sqr)
    let intercept = meany - slope * meanx
    return (slope, intercept)
}

public func mod<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, _ rhs: MR) -> ValueArray<Double> {
    precondition(lhs.step == 1, "mod doesn't support step values other than 1")
    let results = ValueArray<Double>(count: lhs.count)
    vvfmod(results.mutablePointer + results.startIndex, lhs.pointer + lhs.startIndex, rhs.pointer + rhs.startIndex, [Int32(lhs.count)])
    return results
}

public func remainder<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    precondition(lhs.step == 1, "remainder doesn't support step values other than 1")
    let results = ValueArray<Double>(count: lhs.count)
    vvremainder(results.mutablePointer + results.startIndex, lhs.pointer + lhs.startIndex, rhs.pointer + rhs.startIndex, [Int32(lhs.count)])
    return results
}

public func sqrt<M: LinearType where M.Element == Double>(lhs: M) -> ValueArray<Double> {
    precondition(lhs.step == 1, "sqrt doesn't support step values other than 1")
    let results = ValueArray<Double>(count: lhs.count)
    vvsqrt(results.mutablePointer + results.startIndex, lhs.pointer + lhs.startIndex, [Int32(lhs.count)])
    return results
}

public func dot<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, _ rhs: MR) -> Double {
    precondition(lhs.count == rhs.count, "Vectors must have equal count")

    var result: Double = 0.0
    vDSP_dotprD(lhs.pointer + lhs.startIndex, lhs.step, rhs.pointer + rhs.startIndex, rhs.step, &result, vDSP_Length(lhs.count))
    return result
}
