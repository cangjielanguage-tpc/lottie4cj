/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property

func linearOffset(p1: Array<Float64>, p2: Array<Float64>, amount: Float64): Array<Array<Float64>> {
    /**
     * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
     * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
     * Math.atan2(p[1], p[0]) = atan(p[1] / p[0])
     */
    let angle: Float64 = atan((p2[0] - p1[0]) / (p2[1] - p1[1]))
    return [
        polarOffset(p1, angle, amount),
        polarOffset(p2, angle, amount)
    ]
}

func offsetSegment(segment: PolynomialBezier, amount: Float64): PolynomialBezier {
    var e: Array<Array<Float64>> = linearOffset(segment.points[0], segment.points[1], amount)
    let p0: Array<Float64> = e[0]
    let p1a: Array<Float64> = e[1]
    e = linearOffset(segment.points[1], segment.points[2], amount)
    let p1b: Array<Float64> = e[0]
    let p2b: Array<Float64> = e[1]
    e = linearOffset(segment.points[2], segment.points[3], amount)
    let p2a: Array<Float64> = e[0]
    let p3: Array<Float64> = e[1]
    var p1: Array<Float64> = lineIntersection(p0, p1a, p1b, p2b)
    if (p1.size <= 0) {
        p1 = p1a
    }
    var p2: Array<Float64> = lineIntersection(p2a, p3, p1b, p2b)
    if (p2.size <= 0) {
        p2 = p2a
    }

    return PolynomialBezier(p0, p1, p2, p3, false)
}

func joinLines(outputBezier: ShapeData, seg1: PolynomialBezier, seg2: PolynomialBezier, lineJoin: Int64, miterLimit: Float64): Array<Float64> {
    if (seg1.points.size < 4 || seg2.points.size < 1) {
        throw IndexOutOfBoundsException("[joinLines]: seg1.points.size = ${seg1.points.size}, seg2.points.size = ${seg2.points.size}")
    }
    var p0: Array<Float64> = seg1.points[3]
    var p1: Array<Float64> = seg2.points[0]

    /* 斜面 */
    if (lineJoin == 3) { return p0 }

    /* 连接，他们不需要关节 */
    if (pointEqual(p0, p1)) { return p0 }

    /* 圆形 */
    if (lineJoin == 2) {
        let angleOut: Float64 = -seg1.tangentAngle(1.0)
        let angleIn: Float64 = -seg2.tangentAngle(0.0) + Float64.GetPI()
        let center: Array<Float64> = lineIntersection(
            p0,
            polarOffset(p0, angleOut + Float64.GetPI() / 2.0, 100.0),
            p1,
            polarOffset(p1, angleOut + Float64.GetPI() / 2.0, 100.0)
        )
        var radius: Float64 = 0.0
        if (center.size >= 2) {
            radius = pointDistance(center, p0)
        } else {
            radius = pointDistance(p0, p1) / 2.0
        }

        var tan: Array<Float64> = polarOffset(p0, angleOut, 2.0 * radius * roundCorner)
        if (tan.size < 2) {
            throw IndexOutOfBoundsException("[joinLines]: tan.size = ${tan.size}")
        }
        outputBezier.setXYAt(tan[0], tan[1], "o", outputBezier.length() - 1)

        tan = polarOffset(p1, angleIn, 2.0 * radius * roundCorner)
        outputBezier.setTripleAt(p1[0], p1[1], p1[0], p1[1], tan[0], tan[1], outputBezier.length())

        return p1
    }

    /* Miter  斜接 */
    var t0: Array<Float64> = seg1.points[2]
    if (pointEqual(p0, seg1.points[2])) {
        t0 = seg1.points[0]
    }
    var t1: Array<Float64> = seg2.points[1]
    if (pointEqual(p1, seg2.points[1])) {
        t1 = seg2.points[3]
    }
    let intersection: Array<Float64> = lineIntersection(t0, p0, p1, t1)
    if (intersection.size > 2 && pointDistance(intersection, p0) < miterLimit) {
      outputBezier.setTripleAt(
        intersection[0],
        intersection[1],
        intersection[0],
        intersection[1],
        intersection[0],
        intersection[1],
        outputBezier.length()
      )
      return intersection
    }

    return p0
}

func getIntersection(a: PolynomialBezier, b: PolynomialBezier): Array<Float64> {
    let intersect: ArrayList<Array<Float64>> = a.intersections(b, 0.0, 0)

    if (intersect.size > 0 && intersect[0].size > 0 && floatEqual(intersect[0][0], 1.0)) {
        intersect.remove(at: 0)
    }
    if (intersect.size > 0) {
        return intersect[0]
    }
    return Array<Float64>()
}

func pruneSegmentIntersection(a: Array<PolynomialBezier>, b: Array<PolynomialBezier>): Array<Array<PolynomialBezier>> {
    var outa: Array<PolynomialBezier> = a.clone()
    var outb: Array<PolynomialBezier> = b.clone()
    var intersect: Array<Float64> = getIntersection(a[a.size - 1], b[0])
    if (intersect.size > 0) {
        outa[a.size - 1] = a[a.size - 1].split(Float64(intersect[0]))[0]
        outb[0] = b[0].split(Float64(intersect[1]))[1]
    }
    if (a.size > 1 && b.size > 1) {
        intersect = getIntersection(a[0], b[b.size - 1])
        if (intersect.size > 0) {
            return [
                [a[0].split(intersect[0])[0]],
                [b[b.size - 1].split(intersect[1])[1]]
            ]
        }
    }
    return [outa, outb]
}

func pruneIntersections(segments: Array<Array<PolynomialBezier>>): Array<Array<PolynomialBezier>> {
    var e: Array<Array<PolynomialBezier>> = Array<Array<PolynomialBezier>>()
    for (i in 1..segments.size) {
        e = pruneSegmentIntersection(segments[i - 1], segments[i])
        segments[i - 1] = e[0]
        segments[i] = e[1]
    }

    if (segments.size > 1) {
        e = pruneSegmentIntersection(segments[segments.size - 1], segments[0])
        segments[segments.size - 1] = e[0]
        segments[0] = e[1]
    }

    return segments
}

func offsetSegmentSplit(segment: PolynomialBezier, amount: Float64): Array<PolynomialBezier> {
    /**
     * 我们根据拐点将每个贝塞尔线段分割成更小的部分，这确保了控制点多边形是凸的。
     * （三次贝塞尔曲线可以没有拐点、一个拐点或两个拐点）
     */
    let flex: Array<Float64> = segment.inflectionPoints()
    var left: PolynomialBezier = PolynomialBezier()
    var right: PolynomialBezier = PolynomialBezier()
    var split: Array<PolynomialBezier> = Array<PolynomialBezier>()

    if (flex.size == 0) {
        return [offsetSegment(segment, amount)]
    }

    if (flex.size == 1 || floatEqual(flex[1], 1.0)) {
        split = segment.split(flex[0])
        left = split[0]
        right = split[1]

        return [
            offsetSegment(left, amount),
            offsetSegment(right, amount)
        ]
    }

    split = segment.split(flex[0])
    left = split[0]
    let t: Float64 = (flex[1] - flex[0]) / (1.0 - flex[0])
    split = split[1].split(t)
    let mid = split[0]
    right = split[1]

    return [
        offsetSegment(left, amount),
        offsetSegment(mid, amount),
        offsetSegment(right, amount)
    ]
}
