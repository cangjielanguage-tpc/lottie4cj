/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BezierEasing.
 */
//package lottie.third_party
package lottie.bezier


public class BezierEasing {

    //这些值是通过经验主义和测试建立的（权衡：性能与精度）
    let NEWTON_ITERATIONS = 4
    let NEWTON_MIN_SLOPE: Float64 = 0.001
    let SUBDIVISION_PRECISION: Float64 = 0.0000001
    let SUBDIVISION_MAX_ITERATIONS: Int64 = 10

    let kSplineTableSize: Int64 = 11
    let kSampleStepSize: Float64 = 1.0 / (Float64(kSplineTableSize) - 1.0)


    var _p: Array<Float64> = Array<Float64>()
    var _mSampleValues: Array<Float64> = Array<Float64>()
    var _precomputed: Bool = false

    //var beziers: HashMap<String, BezierEasing> = HashMap<String, BezierEasing>(24)

    //points is an array of [ mX1, mY1, mX2, mY2 ]
    init(points: Array<Float64>) {
        this._p = points
        this._mSampleValues = Array<Float64>(kSplineTableSize, item: 0.0)
        this._precomputed = false
        //this.get = this.get.bind(this)
    }

    func A(aA1: Float64, aA2: Float64): Float64 {
        return 1.0 - 3.0 * aA2 + 3.0 * aA1
    }
    func B(aA1: Float64, aA2: Float64): Float64 {
        return 3.0 * aA2 - 6.0 * aA1
    }
    func C(aA1: Float64): Float64 {
        return 3.0 * aA1
    }

    // Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
    func calcBezier(aT: Float64, aA1: Float64, aA2: Float64): Float64 {
        return ((A(aA1, aA2) * aT + B(aA1, aA2)) * aT + C(aA1)) * aT
    }

    // Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
    func getSlope(aT: Float64, aA1: Float64, aA2: Float64): Float64 {
        return 3.0 * A(aA1, aA2) * aT * aT + 2.0 * B(aA1, aA2) * aT + C(aA1)
    }

    func binarySubdivide(aX: Float64, aA: Float64, aB: Float64, mX1: Float64, mX2: Float64): Float64 {
        var aa: Float64 = aA
        var ab: Float64 = aB
        var currentX: Float64 = 0.0
        var currentT: Float64 = 0.0
        var i: Int64 = 0
        do {
            currentT = aa + (ab - aa) / 2.0
            currentX = calcBezier(currentT, mX1, mX2) - aX
            if (currentX > 0.0) {
                ab = currentT
            } else {
                aa = currentT
            }
            i++
        } while (abs(currentX) > SUBDIVISION_PRECISION && i < SUBDIVISION_MAX_ITERATIONS)
        return currentT
    }

    func newtonRaphsonIterate(aX: Float64, aGuessTs: Float64, mX1: Float64, mX2: Float64): Float64 {
        var aGuessT: Float64 = aGuessTs
        for (i in 0..NEWTON_ITERATIONS) {
            var currentSlope: Float64 = getSlope(aGuessT, mX1, mX2)
            if (currentSlope == 0.0) {
                return aGuessT
            }
            let currentX: Float64 = calcBezier(aGuessT, mX1, mX2) - aX
            aGuessT -= (currentX / currentSlope)
        }
        return aGuessT
    }

    //func getBezierEasing(a: Float64, b: Float64, c: Float64, d: Float64, nm: String): BezierEasing {
    //    var str: String = nm
    //    if (nm.isEmpty()) {
    //        str = "bez_" + a + "_" + b + "_" + c + "_" + d
    //    }
    //    str = str.replace(".", "p")
    //    if (beziers.contains(str)) {
    //        return beziers[str]
    //    }
    //    let bezEasing: BezierEasing = BezierEasing([a, b, c, d])
    //    beziers[str] = bezEasing
    //    return bezEasing
    //}
    
    //------------------------------------------------------------------------------------

    public func getOfBezierEasing(x: Float64): Float64 {
        let mX1: Float64 = this._p[0]
        let mY1: Float64 = this._p[1]
        let mX2: Float64 = this._p[2]
        let mY2: Float64 = this._p[3]
        if (!this._precomputed) {
            this._precompute()
        }
        if (mX1 == mY1 && mX2 == mY2) {  // linear
            return x
        }
        //因为JavaScript的数字是不精确的，我们应该保证极端是正确的。
        if (x == 0.0) { return 0.0 }
        if (x == 1.0) { return 1.0 }
        return calcBezier(this._getTForX(x), mY1, mY2)
    }

    private func _precompute() {
        let mX1: Float64 = this._p[0]
        let mY1: Float64 = this._p[1]
        let mX2: Float64 = this._p[2]
        let mY2: Float64 = this._p[3]
        this._precomputed = true
        if (mX1 != mY1 || mX2 != mY2) {
            this._calcSampleValues()
        }
    }

    func _calcSampleValues(): Unit {
        let mX1: Float64 = this._p[0]
        let mX2: Float64 = this._p[2]
        for (i in 0..kSplineTableSize) {
            this._mSampleValues[i] = calcBezier(Float64(i) * kSampleStepSize, mX1, mX2)
        }
    }

    //getTForX选择了最快的启发式方法来精确地从给定的X投影中确定百分比值。
    func _getTForX(aX: Float64): Float64 {
        let mX1: Float64 = this._p[0]
        let mX2: Float64 = this._p[2]
        let mSampleValues: Array<Float64> = this._mSampleValues

        var intervalStart: Float64 = 0.0
        var currentSample: Int64 = 1
        var lastSample: Int64 = kSplineTableSize - 1

        while (currentSample != lastSample && mSampleValues[currentSample] <= aX) {
            intervalStart += kSampleStepSize
            currentSample++
        }
        currentSample--

        // Interpolate to provide an initial guess for t
        var dist: Float64 = (aX - mSampleValues[currentSample]) / (mSampleValues[currentSample + 1] - mSampleValues[currentSample])
        var guessForT: Float64 = intervalStart + dist * kSampleStepSize

        var initialSlope: Float64 = getSlope(guessForT, mX1, mX2)
        if (initialSlope >= NEWTON_MIN_SLOPE) {
            return newtonRaphsonIterate(aX, guessForT, mX1, mX2)
        } else if (initialSlope == 0.0) {
            return guessForT
        }
        return binarySubdivide(aX, intervalStart, intervalStart + kSampleStepSize, mX1, mX2)
    }

}


