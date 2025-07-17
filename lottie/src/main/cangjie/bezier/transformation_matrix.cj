/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.bezier

internal import std.math.*

internal import ohos.hilog.*

public class Matrix {
    public var props: Array<Float64> = Array<Float64>(16, repeat: 0.0)

    var _identity: Bool = true
    var _identityCalculated: Bool = false

    public init() {
        this.props[0] = 1.0
        this.props[5] = 1.0
        this.props[10] = 1.0
        this.props[15] = 1.0
    }

    public func rotate(angle: Float64) {
        if (angle == 0.0) {
            return this
        }
        var mCos = cos(angle)
        var mSin = sin(angle)
        return transform(mCos, -mSin, 0.0, 0.0, mSin, mCos, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func rotateX(angle: Float64) {
        if (angle == 0.0) {
            return this
        }
        var mCos = cos(angle)
        var mSin = sin(angle)
        return transform(1.0, 0.0, 0.0, 0.0, 0.0, mCos, -mSin, 0.0, 0.0, mSin, mCos, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func rotateY(angle: Float64) {
        if (angle == 0.0) {
            return this
        }
        var mCos = cos(angle)
        var mSin = sin(angle)
        return transform(mCos, 0.0, mSin, 0.0, 0.0, 1.0, 0.0, 0.0, -mSin, 0.0, mCos, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func rotateZ(angle: Float64) {
        if (angle == 0.0) {
            return this
        }
        var mCos = cos(angle)
        var mSin = sin(angle)
        return transform(mCos, -mSin, 0.0, 0.0, mSin, mCos, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func shear(sx: Float64, sy: Float64) {
        //return transform(1.0, sy, sx, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    }

    public func skew(ax: Float64, ay: Float64) {
        return this.shear(tan(ax), tan(ay))
    }

    public func skewFromAxis(ax: Float64, angle: Float64) {
        var mCos = cos(angle)
        var mSin = sin(angle)
        return this.transform(mCos, mSin, 0.0, 0.0, -mSin, mCos, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0).
            transform(1.0, 0.0, 0.0, 0.0, tan(ax), 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0).transform(
            mCos, -mSin, 0.0, 0.0, mSin, mCos, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func scale(sx: Float64, sy: Float64, sz!: Float64 = 1.0) {
        if (sx == 1.0 && sy == 1.0 && sz == 1.0) {
            return this
        }
        return this.transform(sx, 0.0, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, 0.0, sz, 0.0, 0.0, 0.0, 0.0, 1.0)
    }

    public func setTransform(a: Float64, b: Float64, c: Float64, d: Float64, e: Float64, f: Float64, g: Float64,
        h: Float64, i: Float64, j: Float64, k: Float64, l: Float64, m: Float64, n: Float64, o: Float64, p: Float64) {
        this.props[0] = Float64(Float32(a))
        this.props[1] = Float64(Float32(b))
        this.props[2] = Float64(Float32(c))
        this.props[3] = Float64(Float32(d))
        this.props[4] = Float64(Float32(e))
        this.props[5] = Float64(Float32(f))
        this.props[6] = Float64(Float32(g))
        this.props[7] = Float64(Float32(h))
        this.props[8] = Float64(Float32(i))
        this.props[9] = Float64(Float32(j))
        this.props[10] = Float64(Float32(k))
        this.props[11] = Float64(Float32(l))
        this.props[12] = Float64(Float32(m))
        this.props[13] = Float64(Float32(n))
        this.props[14] = Float64(Float32(o))
        this.props[15] = Float64(Float32(p))
        return this
    }

    public func translate(tx: Float64, ty: Float64, tz!: Float64 = 0.0) {
        if (tx != 0.0 || ty != 0.0 || tz != 0.0) {
            return this.transform(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, tx, ty, tz, 1.0)
        }
        return this
    }

    public func transform(a2: Float64, b2: Float64, c2: Float64, d2: Float64, e2: Float64, f2: Float64, g2: Float64,
        h2: Float64, i2: Float64, j2: Float64, k2: Float64, l2: Float64, m2: Float64, n2: Float64, o2: Float64,
        p2: Float64) {
        var _p = this.props

        if (a2 == 1.0 && b2 == 0.0 && c2 == 0.0 && d2 == 0.0 && e2 == 0.0 && f2 == 1.0 && g2 == 0.0 && h2 == 0.0 &&
            i2 == 0.0 && j2 == 0.0 && k2 == 1.0 && l2 == 0.0) {
            // NOTE: commenting this condition because TurboFan deoptimizes code when present
            _p[12] = Float64(Float32(_p[12] * a2 + _p[15] * m2))
            _p[13] = Float64(Float32(_p[13] * f2 + _p[15] * n2))
            _p[14] = Float64(Float32(_p[14] * k2 + _p[15] * o2))
            _p[15] = Float64(Float32(_p[15]*p2))
            this._identityCalculated = false
            return this
        }

        var a1 = _p[0]
        var b1 = _p[1]
        var c1 = _p[2]
        var d1 = _p[3]
        var e1 = _p[4]
        var f1 = _p[5]
        var g1 = _p[6]
        var h1 = _p[7]
        var i1 = _p[8]
        var j1 = _p[9]
        var k1 = _p[10]
        var l1 = _p[11]
        var m1 = _p[12]
        var n1 = _p[13]
        var o1 = _p[14]
        var p1 = _p[15]

        /* matrix order (canvas compatible):
         * ace
         * bdf
         * 001
         */
        _p[0] = Float64(Float32(a1 * a2 + b1 * e2 + c1 * i2 + d1 * m2))
        _p[1] = Float64(Float32(a1 * b2 + b1 * f2 + c1 * j2 + d1 * n2))
        _p[2] = Float64(Float32(a1 * c2 + b1 * g2 + c1 * k2 + d1 * o2))
        _p[3] = Float64(Float32(a1 * d2 + b1 * h2 + c1 * l2 + d1 * p2))

        _p[4] = Float64(Float32(e1 * a2 + f1 * e2 + g1 * i2 + h1 * m2))
        _p[5] = Float64(Float32(e1 * b2 + f1 * f2 + g1 * j2 + h1 * n2))
        _p[6] = Float64(Float32(e1 * c2 + f1 * g2 + g1 * k2 + h1 * o2))
        _p[7] = Float64(Float32(e1 * d2 + f1 * h2 + g1 * l2 + h1 * p2))

        _p[8] = Float64(Float32(i1 * a2 + j1 * e2 + k1 * i2 + l1 * m2))
        _p[9] = Float64(Float32(i1 * b2 + j1 * f2 + k1 * j2 + l1 * n2))
        _p[10] = Float64(Float32(i1 * c2 + j1 * g2 + k1 * k2 + l1 * o2))
        _p[11] = Float64(Float32(i1 * d2 + j1 * h2 + k1 * l2 + l1 * p2))

        _p[12] = Float64(Float32(m1 * a2 + n1 * e2 + o1 * i2 + p1 * m2))
        _p[13] = Float64(Float32(m1 * b2 + n1 * f2 + o1 * j2 + p1 * n2))
        _p[14] = Float64(Float32(m1 * c2 + n1 * g2 + o1 * k2 + p1 * o2))
        _p[15] = Float64(Float32(m1 * d2 + n1 * h2 + o1 * l2 + p1 * p2))

        this._identityCalculated = false
        return this
    }

    public func isIdentity() {
        if (!this._identityCalculated) {
            this._identity = !(this.props[0] != 1.0 || this.props[1] != 0.0 || this.props[2] != 0.0 || this.props[3] !=
                0.0 || this.props[4] != 0.0 || this.props[5] != 1.0 || this.props[6] != 0.0 || this.props[7] != 0.0 ||
                this.props[8] != 0.0 || this.props[9] != 0.0 || this.props[10] != 1.0 || this.props[11] != 0.0 ||
                this.props[12] != 0.0 || this.props[13] != 0.0 || this.props[14] != 0.0 || this.props[15] != 1.0)
            this._identityCalculated = true
        }
        return this._identity
    }

    public func equals(matr: Matrix) {
        var i = 0
        while (i < 16) {
            if (matr.props[i] != this.props[i]) {
                return false
            }
            i += 1
        }
        return true
    }

    public func clone(matr: Matrix) {
        for (i in 0..16) {
            matr.props[i] = this.props[i]
        }
        return matr
    }

    public func cloneFromProps(props: Array<Float64>) {
        for (i in 0..16) {
            this.props[i] = props[i]
        }
    }

    public func applyToPoint(x: Float64, y: Float64, z: Float64) {
        return (x * this.props[0] + y * this.props[4] + z * this.props[8] + this.props[12],
            x * this.props[1] + y * this.props[5] + z * this.props[9] + this.props[13],
            x * this.props[2] + y * this.props[6] + z * this.props[10] + this.props[14])
        /* return {
            x: x * me.a + y * me.c + me.e,
            y: x * me.b + y * me.d + me.f
            }; */
    }

    public func applyToX(x: Float64, y: Float64, z: Float64) {
        return x * this.props[0] + y * this.props[4] + z * this.props[8] + this.props[12]
    }

    public func applyToY(x: Float64, y: Float64, z: Float64) {
        return x * this.props[1] + y * this.props[5] + z * this.props[9] + this.props[13]
    }

    public func applyToZ(x: Float64, y: Float64, z: Float64) {
        return x * this.props[2] + y * this.props[6] + z * this.props[10] + this.props[14]
    }

    public func getInverseMatrix() {
        var determinant = this.props[0] * this.props[5] - this.props[1] * this.props[4]
        var a = this.props[5] / determinant
        var b = -this.props[1] / determinant
        var c = -this.props[4] / determinant
        var d = this.props[0] / determinant
        var e = (this.props[4] * this.props[13] - this.props[5] * this.props[12]) / determinant
        var f = -(this.props[0] * this.props[13] - this.props[1] * this.props[12]) / determinant
        var inverseMatrix = Matrix()
        inverseMatrix.props[0] = a
        inverseMatrix.props[1] = b
        inverseMatrix.props[4] = c
        inverseMatrix.props[5] = d
        inverseMatrix.props[12] = e
        inverseMatrix.props[13] = f
        return inverseMatrix;
    }

    public func inversePoint(pt: Array<Float64>) {
        var inverseMatrix = this.getInverseMatrix()
        if (pt.size > 2) {
            return inverseMatrix.applyToPointArray(pt[0], pt[1], pt[2])
        } else {
            return inverseMatrix.applyToPointArray(pt[0], pt[1], 0.0)
        }
    }

    public func inversePoints(pts: Array<Array<Float64>>) {
        var len = pts.size
        let retPts = pts |> map{v=>inversePoint(v)} |> collectArray
        return retPts
    }

    public func applyToTriplePoints(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>) {
        var arr = Array<Float64>(6, repeat: 0.0)
        if (this.isIdentity()) {
            arr[0] = pt1[0]
            arr[1] = pt1[1]
            arr[2] = pt2[0]
            arr[3] = pt2[1]
            arr[4] = pt3[0]
            arr[5] = pt3[1]
        } else {
            var p0 = this.props[0]
            var p1 = this.props[1]
            var p4 = this.props[4]
            var p5 = this.props[5]
            var p12 = this.props[12]
            var p13 = this.props[13]
            arr[0] = pt1[0] * p0 + pt1[1] * p4 + p12
            arr[1] = pt1[0] * p1 + pt1[1] * p5 + p13
            arr[2] = pt2[0] * p0 + pt2[1] * p4 + p12
            arr[3] = pt2[0] * p1 + pt2[1] * p5 + p13
            arr[4] = pt3[0] * p0 + pt3[1] * p4 + p12
            arr[5] = pt3[0] * p1 + pt3[1] * p5 + p13
        }
        return arr
    }

    public func applyToPointArray(x: Float64, y: Float64, z: Float64): Array<Float64> {
        if (this.isIdentity()) {
            return [x, y, z]
        } else {
            return [x * this.props[0] + y * this.props[4] + z * this.props[8] + this.props[12],
                x * this.props[1] + y * this.props[5] + z * this.props[9] + this.props[13],
                x * this.props[2] + y * this.props[6] + z * this.props[10] + this.props[14]]
        }
    }

    public func applyToPointStringified(x: Float64, y: Float64) {
        if (this.isIdentity()) {
            return "${x}" + "," + "${y}"
        }
        var _p = this.props;
        return "${round((x * _p[0] + y * _p[4] + _p[12]) * 100.0) / 100.0}" + "," + "${round((x * _p[1] + y * _p[5] + _p[13]) * 100.0) / 100.0}"
    }

    public func toCSS() {
        // Doesn't make much sense to add this optimization. If it is an identity matrix, it's very likely this will get called only once since it won't be keyframed.
        var i = 0
        var props = this.props
        var cssValue = "matrix3d("
        var v: Float64 = 10000.0
        while (i < 16) {
            cssValue += "${round(props[i] * v) / v}"
            if (i == 15) {
                cssValue += ")"
            } else {
                cssValue += ","
            }
            i += 1
        }
        return cssValue
    }

    public func roundMatrixProperty(val: Float64) {
        var v: Float64 = 10000.0
        if ((val < 0.000001 && val > 0.0) || (val > -0.000001 && val < 0.0)) {
            return round(val * v) / v
        }
        return val
    }

    public func to2dCSS() {
        // Doesn't make much sense to add this optimization. If it is an identity matrix, it's very likely this will get called only once since it won't be keyframed.
        var props = this.props;
        var _a = roundMatrixProperty(props[0])
        var _b = roundMatrixProperty(props[1])
        var _c = roundMatrixProperty(props[4])
        var _d = roundMatrixProperty(props[5])
        var _e = roundMatrixProperty(props[12])
        var _f = roundMatrixProperty(props[13])
        return "matrix(" + "${_a}" + "," + "${_b}" + "," + "${_c}" + "," + "${_d}" + "," + "${_e}" + "," + "${_f}" + ")"
    }

    public func reset() {
        this.props[0] = 1.0
        this.props[1] = 0.0

        this.props[2] = 0.0
        this.props[3] = 0.0
        this.props[4] = 0.0
        this.props[5] = 1.0
        this.props[6] = 0.0
        this.props[7] = 0.0
        this.props[8] = 0.0
        this.props[9] = 0.0
        this.props[10] = 1.0
        this.props[11] = 0.0
        this.props[12] = 0.0
        this.props[13] = 0.0
        this.props[14] = 0.0
        this.props[15] = 1.0
        return this
    }
}
