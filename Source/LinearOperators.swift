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

public func +=<ML: MutableLinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) {
    assert(lhs.count >= rhs.count)
    let count = min(lhs.count, rhs.count)
    vDSP_vaddD(lhs.pointer + lhs.startIndex, lhs.step, rhs.pointer + rhs.startIndex, rhs.step, lhs.mutablePointer, lhs.step, vDSP_Length(count))
}

public func +<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: count)
    vDSP_vaddD(lhs.pointer + lhs.startIndex, lhs.step, rhs.pointer + rhs.startIndex, rhs.step, results.mutablePointer, results.step, vDSP_Length(count))
    return results
}

public func +=<ML: MutableLinearType where ML.Element == Double>(lhs: ML, var rhs: Double) {
    vDSP_vsaddD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(lhs.count))
}

public func +<ML: LinearType where ML.Element == Double>(lhs: ML, var rhs: Double) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: lhs.count)
    vDSP_vsaddD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    return results
}

public func +<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: Double, rhs: MR) -> ValueArray<Double> {
    return rhs + lhs
}

public func -=<ML: MutableLinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) {
    let count = min(lhs.count, rhs.count)
    vDSP_vsubD(rhs.pointer + rhs.startIndex, rhs.step, lhs.pointer + lhs.startIndex, lhs.step, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(count))
}

public func -<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: count)
    vDSP_vsubD(rhs.pointer + rhs.startIndex, rhs.step, lhs.pointer + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    return results
}

public func -=<ML: MutableLinearType where ML.Element == Double>(lhs: ML, rhs: Double) {
    var scalar: Double = -rhs
    vDSP_vsaddD(lhs.pointer + lhs.startIndex, lhs.step, &scalar, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(lhs.count))
}

public func -<ML: LinearType where ML.Element == Double>(lhs: ML, rhs: Double) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: lhs.count)
    var scalar: Double = -rhs
    vDSP_vsaddD(lhs.pointer + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    return results
}

public func -<ML: LinearType where ML.Element == Double>(var lhs: Double, rhs: ML) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: rhs.count)
    var scalar: Double = -1
    vDSP_vsmsaD(rhs.pointer + rhs.startIndex, rhs.step, &scalar, &lhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    return results
}

public func /=<ML: MutableLinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) {
    let count = min(lhs.count, rhs.count)
    vDSP_vdivD(rhs.pointer + rhs.startIndex, rhs.step, lhs.pointer + lhs.startIndex, lhs.step, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(count))
}

public func /<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: lhs.count)
    vDSP_vdivD(rhs.pointer + rhs.startIndex, rhs.step, lhs.pointer + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    return results
}

public func /=<ML: MutableLinearType where ML.Element == Double>(lhs: ML, var rhs: Double) {
    vDSP_vsdivD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(lhs.count))
}

public func /<ML: LinearType where ML.Element == Double>(lhs: ML, var rhs: Double) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: lhs.count)
    vDSP_vsdivD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    return results
}

public func /<ML: LinearType where ML.Element == Double>(var lhs: Double, rhs: ML) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: rhs.count)
    vDSP_svdivD(&lhs, rhs.pointer + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    return results
}

public func *=<ML: MutableLinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) {
    vDSP_vmulD(lhs.pointer + lhs.startIndex, lhs.step, rhs.pointer + rhs.startIndex, rhs.step, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(lhs.count))
}

public func *<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: lhs.count)
    vDSP_vmulD(lhs.pointer + lhs.startIndex, lhs.step, rhs.pointer + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    return results
}

public func *=<ML: MutableLinearType where ML.Element == Double>(lhs: ML, var rhs: Double) {
    vDSP_vsmulD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, lhs.mutablePointer + lhs.startIndex, lhs.step, vDSP_Length(lhs.count))
}

public func *<ML: LinearType where ML.Element == Double>(lhs: ML, var rhs: Double) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: lhs.count)
    vDSP_vsmulD(lhs.pointer + lhs.startIndex, lhs.step, &rhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    return results
}

public func *<ML: LinearType where ML.Element == Double>(lhs: Double, rhs: ML) -> ValueArray<Double> {
    return rhs * lhs
}

public func %<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    return mod(lhs, rhs)
}

public func %<ML: LinearType where ML.Element == Double>(lhs: ML, rhs: Double) -> ValueArray<Double> {
    return mod(lhs, ValueArray<Double>(count: lhs.count, repeatedValue: rhs))
}

infix operator • {}
public func •<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> Double {
    return dot(lhs, rhs)
}
