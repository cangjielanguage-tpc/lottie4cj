/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.inner


/**
 * Float equal.
 *
 * @param a - Type of Float64.
 * @param b - Type of Float64.
 * @return Type of Bool.
 */
public func floatEqual(a: Float64, b: Float64): Bool {
    return abs(a - b) * 100000.0 <= min(abs(a), abs(b))
}

func floatZero(f: Float64): Bool {
    return abs(f) <= 0.00001
}

func lerp(p0: Float64, p1: Float64, amount: Float64): Float64 {
    return p0 * (1.0 - amount) + p1 * amount
}

func lerpPoint(p0: Array<Float64>, p1: Array<Float64>, amount: Float64): Array<Float64> {
    if (p0.size < 2 || p1.size < 2) {
        throw IndexOutOfBoundsException("[lerpPoint]: p0.size = ${p0.size}, p1.size = ${p1.size}")
    }
    return [lerp(p0[0], p1[0], amount), lerp(p0[1], p1[1], amount)]
}

func quadRoots(a: Float64, b: Float64, c: Float64): Array<Float64> {
    // no root
    if (a == 0.0) {
        return Array<Float64>()
    }
    let s: Float64 = b * b - 4.0 * a * c
    // Complex roots
    if (s < 0.0) {
        return Array<Float64>()
    }
    let singleRoot: Float64 = -b / (2.0 * a)
    // 1 root
    if (s == 0.0) {
        return [singleRoot]
    }
    let delta: Float64 = sqrt(s) / (2.0 * a)
    // 2 roots
    return [singleRoot - delta, singleRoot + delta]
}

func polynomialCoefficients(p0: Float64, p1: Float64, p2: Float64, p3: Float64): Array<Float64> {
    return [
        -p0 + 3.0 * p1 - 3.0 * p2 + p3,
        3.0 * p0 - 6.0 * p1 + 3.0 * p2,
        -3.0 * p0 + 3.0 * p1,
        p0
    ]
}

func singlePoint(p: Array<Float64>): PolynomialBezier {
    return PolynomialBezier(p, p, p, p, false)
}


func extrema(bez: PolynomialBezier, comp: Int64): ExtremaPoint {
    if (bez.points.size <= 0 || bez.points[0].size < comp) {
        throw IndexOutOfBoundsException("[extrema]: bez.points.size = ${bez.points.size}, bez.points[0].size = ${bez.points[0].size}")
    }
    var min: Float64 = bez.points[0][comp]
    if (bez.points[bez.points.size - 1].size < comp) {
        throw IndexOutOfBoundsException("[extrema]: bez.points[bez.points.size - 1].size = ${bez.points[bez.points.size - 1].size}")
    }
    var max: Float64 = bez.points[bez.points.size - 1][comp]
    if (min > max) {
        var e: Float64 = max
        max = min
        min = e
    }
    if (bez.a.size < comp || bez.b.size < comp || bez.c.size < comp) {
        throw IndexOutOfBoundsException("[extrema]: bez.a.size = ${bez.a.size}, bez.b.size = ${bez.b.size}, bez.c.size = ${bez.c.size}")
    }
    // Derivative roots to find min/max
    var f: Array<Float64> = quadRoots(3.0 * bez.a[comp], 2.0 * bez.b[comp], bez.c[comp])
    for (i in 0..f.size) {
        if (f[i] > 0.0 && f[i] < 1.0) {
            let val: Float64 = bez.point(f[i])[comp]
            if (val < min) {
                min = val
            } else if (val > max) {
                max = val
            }
        }
    }
    return ExtremaPoint(
      min: min,
      max: max
    )
}


func intersectData(bez: PolynomialBezier, t1: Float64, t2: Float64): BoundingBoxObject {
    let box: BoundingBoxObject = bez.boundingBox()
    return BoundingBoxObject(
        width: box.width,
        height: box.height,
        cx: box.cx,
        cy: box.cy,
        bez: bez,
        t: (t1 + t2) / 2.0,
        t1: t1,
        t2: t2
    )
}

func splitData(data: BoundingBoxObject): Array<BoundingBoxObject> {
    let split: Array<PolynomialBezier> = data.bez.split(0.5)
    if (split.size < 2) {
        throw IndexOutOfBoundsException("[splitData]: split.size = ${split.size}")
    }
    return [
        intersectData(split[0], data.t1, data.t),
        intersectData(split[1], data.t, data.t2)
    ]
}

func boxIntersect(b1: BoundingBoxObject, b2: BoundingBoxObject): Bool {
    return abs(b1.cx - b2.cx) * 2.0 < b1.width + b2.width && 
            abs(b1.cy - b2.cy) * 2.0 < b1.height + b2.height
}

func intersectsImpl(d1: BoundingBoxObject, d2: BoundingBoxObject, depth: Int64, tolerance: Float64, 
                    intersectionsArr: ArrayList<Array<Float64>>, maxRecursion: Int64
): Unit {
    if (!boxIntersect(d1, d2)) {
        return
    }
    if (depth >= maxRecursion || (d1.width <= tolerance && d1.height <= tolerance && d2.width <= tolerance && d2.height <= tolerance)) {
        intersectionsArr.add([d1.t, d2.t])
        return
    }
    let d1s: Array<BoundingBoxObject> = splitData(d1)
    let d2s: Array<BoundingBoxObject> = splitData(d2)
    intersectsImpl(d1s[0], d2s[0], depth + 1, tolerance, intersectionsArr, maxRecursion)
    intersectsImpl(d1s[0], d2s[1], depth + 1, tolerance, intersectionsArr, maxRecursion)
    intersectsImpl(d1s[1], d2s[0], depth + 1, tolerance, intersectionsArr, maxRecursion)
    intersectsImpl(d1s[1], d2s[1], depth + 1, tolerance, intersectionsArr, maxRecursion)
}


func crossProduct(a: Array<Float64>, b: Array<Float64>): Array<Float64> {
    if (a.size < 3 || b.size < 3) {
        throw IndexOutOfBoundsException("[crossProduct]: a.size = ${a.size}, b.size = ${b.size}")
    }
    return [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0]
    ]
}

/**
 * Calculate line intersection.
 *
 * @param start1 - Type of Array<Float64>.
 * @param end1 - Type of Array<Float64>.
 * @param start2 - Type of Array<Float64>.
 * @param end2 - Type of Array<Float64>.
 * @return Type of Array<Float64>.
 */
public func lineIntersection(start1: Array<Float64>, end1: Array<Float64>, start2: Array<Float64>, end2: Array<Float64>): Array<Float64> {
    if (start1.size < 2 || end1.size < 2 || start2.size < 2 || end2.size < 2) {
        throw IndexOutOfBoundsException("[lineIntersection]: start1.size = ${start1.size}, end1.size = ${end1.size}, start2.size = ${start2.size}, end2.size = ${end2.size}")
    }
    let v1: Array<Float64> = [start1[0], start1[1], 1.0]
    let v2: Array<Float64> = [end1[0], end1[1], 1.0]
    let v3: Array<Float64> = [start2[0], start2[1], 1.0]
    let v4: Array<Float64> = [end2[0], end2[1], 1.0]

    let r = crossProduct(
        crossProduct(v1, v2),
        crossProduct(v3, v4)
    )

    if (floatZero(r[2])) {
        return Array<Float64>()
    }

    return [r[0] / r[2], r[1] / r[2]]
}

/**
 * Calculate polar offset.
 *
 * @param p - Type of Array<Float64>.
 * @param angle - Type of Float64.
 * @param length - Type of Float64.
 * @return Type of Array<Float64>.
 */
public func polarOffset(p: Array<Float64>, angle: Float64, length: Float64): Array<Float64> {
    if (p.size < 2) {
        throw IndexOutOfBoundsException("[polarOffset]: p.size = ${p.size}")
    }
    return [
        p[0] + cos(angle) * length,
        p[1] - sin(angle) * length
    ]
}

/**
 * Calculate point distance.
 *
 * @param p1 - Type of Array<Float64>.
 * @param p2 - Type of Array<Float64>.
 * @return Type of Float64.
 */
public func pointDistance(p1: Array<Float64>, p2: Array<Float64>): Float64 {
    if (p1.size < 2 || p2.size < 2) {
        throw IndexOutOfBoundsException("[pointDistance]: p1.size = ${p1.size}, p2.size = ${p2.size}")
    }
    /**
     * Math.hypot()方法的功能就是先计算它的所有参数的平方和，再返回该和的平方根。
     */
    let num1 = p1[0] - p2[0]
    let num2 = p1[1] - p2[1]
    return sqrt((num1 * num1) + (num2 * num2))
}

/**
 * The judgment points are equal.
 *
 * @param p1 - Type of Array<Float64>.
 * @param p2 - Type of Array<Float64>.
 * @return Type of Bool.
 */
public func pointEqual(p1: Array<Float64>, p2: Array<Float64>): Bool {
    if (p1.size < 2 || p2.size < 2) {
        throw IndexOutOfBoundsException("[pointEqual]: p1.size = ${p1.size}, p2.size = ${p2.size}")
    }
    return floatEqual(p1[0], p2[0]) && floatEqual(p1[1], p2[1])
}

public class ExtremaPoint {
    var min: Float64
    var max: Float64
    
    /**
     * Create a ExtremaPoint instance based on parameters.
     *
     * @param min - Type of Float64, the value of min.
     * @param max - Type of Float64, the value of max.
     */
    public init (min!: Float64 = 0.0, max!: Float64 = 0.0) {
        this.min = min
        this.max = max
    }
}

public class PointArray {

    var x: ExtremaPoint
    var y: ExtremaPoint

    /**
     * Create a PointArray instance based on parameters.
     *
     * @param x - Type of ExtremaPoint, the value of x.
     * @param y - Type of ExtremaPoint, the value of y.
     */
    public init(x!: ExtremaPoint = ExtremaPoint(), y!: ExtremaPoint = ExtremaPoint()) {
        this.x = x
        this.y = y
    }
}

public class BoundingBoxObject {
    var left: Float64
    var right: Float64
    var top: Float64
    var bottom: Float64
    var width: Float64
    var height: Float64
    var cx: Float64
    var cy: Float64
    
    var bez: PolynomialBezier
    var t: Float64
    var t1: Float64
    var t2: Float64
    
    /**
     * Create a BoundingBoxObject instance based on parameters.
     *
     * @param left - Type of Float64, the value of left.
     * @param right - Type of Float64, the value of right.
     * @param top - Type of Float64, the value of top.
     * @param bottom - Type of Float64, the value of bottom.
     * @param width - Type of Float64, the value of width.
     * @param height - Type of Float64, the value of height.
     * @param cx - Type of Float64, the value of cx.
     * @param cy - Type of Float64, the value of cy.
     * @param bez - Type of PolynomialBezier, the value of bez.
     * @param t - Type of Float64, the value of t.
     * @param t1 - Type of Float64, the value of t1.
     * @param t2 - Type of Float64, the value of t2.
     */
    public init(
        left!: Float64 = 0.0,
        right!: Float64 = 0.0,
        top!: Float64 = 0.0,
        bottom!: Float64 = 0.0,
        width!: Float64 = 0.0,
        height!: Float64 = 0.0,
        cx!: Float64 = 0.0,
        cy!: Float64 = 0.0,
        bez!: PolynomialBezier = PolynomialBezier(),
        t!: Float64 = 0.0,
        t1!: Float64 = 0.0,
        t2!: Float64= 0.0
    ){
        this.left = left
        this.right = right
        this.top = top
        this.bottom = bottom
        this.width = width
        this.height = height
        this.cx = cx
        this.cy = cy
        this.bez = bez
        this.t = t
        this.t1 = t1
        this.t2 = t2
    }
}

