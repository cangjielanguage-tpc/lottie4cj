/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.inner

internal import std.math.*
internal import std.collection.*

public class PolynomialBezier {

    var a: Array<Float64> = Array<Float64>()
    var b: Array<Float64> = Array<Float64>()
    var c: Array<Float64> = Array<Float64>()
    var d: Array<Float64> = Array<Float64>()
    var points: Array<Array<Float64>> = Array<Array<Float64>>()
    
    init(){}

    /**
     * Create a PolynomialBezier instance based on parameters.
     *
     * @param p0 - Type of Array<Float64>.
     * @param p1a - Type of Array<Float64>.
     * @param p2a - Type of Array<Float64>.
     * @param p3 - Type of Array<Float64>.
     * @param linearize - Type of Bool.
     */
    public init(p0: Array<Float64>, p1a: Array<Float64>, p2a: Array<Float64>, p3: Array<Float64>, linearize: Bool) {
        var p1: Array<Float64> = p1a
        var p2: Array<Float64> = p2a
        if (linearize && pointEqual(p0, p1)) {
            p1 = lerpPoint(p0, p3, 1.0 / 3.0)
        }
        if (linearize && pointEqual(p2, p3)) {
            p2 = lerpPoint(p0, p3, 2.0 / 3.0)
        }
        let coeffx: Array<Float64> = polynomialCoefficients(p0[0], p1[0], p2[0], p3[0])
        let coeffy: Array<Float64> = polynomialCoefficients(p0[1], p1[1], p2[1], p3[1])
        this.a = [coeffx[0], coeffy[0]]
        this.b = [coeffx[1], coeffy[1]]
        this.c = [coeffx[2], coeffy[2]]
        this.d = [coeffx[3], coeffy[3]]
        this.points = [p0, p1, p2, p3]
    }

    /**
     * Get the point.
     *
     * @param t - Type of Float64.
     * @return Type of Array<Float64>.
     */
    public func point(t: Float64): Array<Float64> {
        return [
            (((this.a[0] * t) + this.b[0]) * t + this.c[0]) * t + this.d[0],
            (((this.a[1] * t) + this.b[1]) * t + this.c[1]) * t + this.d[1]
        ]
    }

    /**
     * Get the derivative.
     *
     * @param t - Type of Float64.
     * @return Type of Array<Float64>.
     */
    public func derivative(t: Float64): Array<Float64> {
        return [
            (3.0 * t * this.a[0] + 2.0 * this.b[0]) * t + this.c[0],
            (3.0 * t * this.a[1] + 2.0 * this.b[1]) * t + this.c[1]
        ]
    }

    /**
     * Get the tangent angle.
     *
     * @param t - Type of Float64.
     * @return Type of Float64.
     */
    public func tangentAngle(t: Float64): Float64 {
        let p: Array<Float64> = this.derivative(t)
        if (p.size < 2) {
            throw IndexOutOfBoundsException("[tangentAngle]: p.size = ${p.size}")
        }
        /**
         * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
         * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
         */
        return atan(p[1] / p[0])
    }

    /**
     * Get the normal angle.
     *
     * @param t - Type of Float64.
     * @return Type of Float64.
     */
    public func normalAngle(t: Float64): Float64 {
        let p: Array<Float64> = this.derivative(t)
        if (p.size < 2) {
            throw IndexOutOfBoundsException("[normalAngle]: p.size = ${p.size}")
        }
        /**
         * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
         * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
         */
        return atan(p[0] / p[1])
    }

    /**
     * Get the inflection points.
     *
     * @return Type of Array<Float64>.
     */
    public func inflectionPoints(): Array<Float64> {
        let denom: Float64 = this.a[1] * this.b[0] - this.a[0] * this.b[1]
        if (floatZero(denom)) {
            return Array<Float64>()
        }
        let tcusp: Float64 = (-0.5 * (this.a[1] * this.c[0] - this.a[0] * this.c[1])) / denom
        let square: Float64 = tcusp * tcusp - ((1.0 / 3.0) * (this.b[1] * this.c[0] - this.b[0] * this.c[1])) / denom
        if (square < 0.0) {
            return Array<Float64>()
        }
        let root: Float64 = sqrt(square)
        if (floatZero(root)) {
            if (root > 0.0 && root < 1.0) {
                return [tcusp]
            }
            return Array<Float64>()
        }
        return filterInflectionPoints(tcusp - root, tcusp + root)
    }
    
    func filterInflectionPoints(num1: Float64, num2: Float64): Array<Float64> {
        var flag1: Bool = false
        var flag2: Bool = false
        if (num1 > 0.0 && num1 < 1.0) {
            flag1 = true
        }
        if (num2 > 0.0 && num2 < 1.0) {
            flag2 = true
        }
        
        if (flag1 && flag2) {
            return [num1, num2]
        } else if (flag1 && !flag2) {
            return [num1]
        } else if (!flag1 && flag2) {
            return [num2]
        } else {
            return Array<Float64>()
        }
    }

    /**
     * Get the polynomial bezier.
     *
     * @param t - Type of Float64.
     * @return Type of Array<PolynomialBezier>.
     */
    public func split(t: Float64): Array<PolynomialBezier> {
        if (t <= 0.0) {
            return [singlePoint(this.points[0]), this]
        }
        if (t >= 1.0) {
            return [this, singlePoint(this.points[this.points.size - 1])]
        }
        let p10: Array<Float64> = lerpPoint(this.points[0], this.points[1], t)
        let p11: Array<Float64> = lerpPoint(this.points[1], this.points[2], t)
        let p12: Array<Float64> = lerpPoint(this.points[2], this.points[3], t)
        let p20: Array<Float64> = lerpPoint(p10, p11, t)
        let p21: Array<Float64> = lerpPoint(p11, p12, t)
        let p3 : Array<Float64> = lerpPoint(p20, p21, t)
        return [
            PolynomialBezier(this.points[0], p10, p20, p3, true),
            PolynomialBezier(p3, p21, p12, this.points[3], true)
        ]
    }

    /**
     * Get the bounds.
     *
     * @return Type of PointArray.
     */
    public func bounds(): PointArray {
        return PointArray(
            x: extrema(this, 0),
            y: extrema(this, 1)
        )
    }

    /**
     * Get the boundary box.
     *
     * @return Type of PointArray.
     */
    public func boundingBox(): BoundingBoxObject {
        let bounds: PointArray = this.bounds()
        return BoundingBoxObject(
          left: bounds.x.min,
          right: bounds.x.max,
          top: bounds.y.min,
          bottom: bounds.y.max,
          width: bounds.x.max - bounds.x.min,
          height: bounds.y.max - bounds.y.min,
          cx: (bounds.x.max + bounds.x.min) / 2.0,
          cy: (bounds.y.max + bounds.y.min) / 2.0
        )
    }

    /**
     * Get the intersections.
     *
     * @param other - Type of PolynomialBezier.
     * @param tolerance1 - Type of Float64.
     * @param maxRecursion1 - Type of Int64.
     * @return Type of ArrayList<Int64>.
     */
    public func intersections(other: PolynomialBezier, tolerance1: Float64, maxRecursion1: Int64): ArrayList<Int64> {
        var tolerance: Float64 = tolerance1
        var maxRecursion: Int64 = maxRecursion1
        if (tolerance <= 0.0) {
            tolerance = 2.0
        }
        if (maxRecursion <= 0) {
            maxRecursion = 7
        }
        var intersections: ArrayList<Int64> = ArrayList<Int64>(24)
        intersectsImpl(intersectData(this, 0, 1), intersectData(other, 0, 1), 0, tolerance, intersections, maxRecursion)
        return intersections
    }

    /**
     * Shape segment.
     *
     * @param shapePath - Type of ShapeData.
     * @param index - Type of Int64.
     * @return Type of PolynomialBezier.
     */
    public static func shapeSegment(shapePath: ShapeData, index: Int64): PolynomialBezier {
        //TODO: shapePath.length() ？？？   //var nextIndex = (index + 1) % shapePath.length();
        let nextIndex: Int64 = index + 1
        
        let p0: Array<Float64> = [shapePath.v[index].x, shapePath.v[index].y]
        let p1: Array<Float64> = [shapePath.o[index].x, shapePath.o[index].y]
        let p2: Array<Float64> = [shapePath.i[nextIndex].x, shapePath.i[nextIndex].y]
        let p3: Array<Float64> = [shapePath.v[nextIndex].x, shapePath.v[nextIndex].y]
        return PolynomialBezier(p0, p1, p2, p3, true)
    }

    /**
     * Shape segment inverted.
     *
     * @param shapePath - Type of ShapeData.
     * @param index - Type of Int64.
     * @return Type of PolynomialBezier.
     */
    public static func shapeSegmentInverted(shapePath: ShapeData, index: Int64): PolynomialBezier {
        //TODO: shapePath.length() ？？？   //var nextIndex = (index + 1) % shapePath.length();
        let nextIndex: Int64 = index + 1
        
        let p0: Array<Float64> = [shapePath.v[nextIndex].x, shapePath.v[nextIndex].y]
        let p1: Array<Float64> = [shapePath.i[nextIndex].x, shapePath.i[nextIndex].y]
        let p2: Array<Float64> = [shapePath.o[index].x, shapePath.o[index].y]
        let p3: Array<Float64> = [shapePath.v[index].x, shapePath.v[index].y]
        return PolynomialBezier(p0, p1, p2, p3, true)
    }

}
