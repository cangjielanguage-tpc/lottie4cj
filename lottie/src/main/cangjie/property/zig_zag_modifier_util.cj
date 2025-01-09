/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.property

func setPoint(outputBezier: ShapeData, point: PointF, angle: Float64, direction: Float64, amplitude: Float64, outAmplitude: Float64, inAmplitude: Float64): Unit {
    setPoint(outputBezier, [point.x, point.y], angle, direction, amplitude, outAmplitude, inAmplitude)
}

func setPoint(outputBezier: ShapeData, point: Array<Float64>, angle: Float64, direction: Float64, amplitude: Float64, outAmplitude: Float64, inAmplitude: Float64): Unit {
    let angO = angle - Float64.PI / 2.0
    let angI = angle + Float64.PI / 2.0
    let px: Float64 = point[0] + cos(angle) * direction * amplitude
    let py: Float64 = point[1] - sin(angle) * direction * amplitude

    outputBezier.setTripleAt(
        px,
        py,
        px + cos(angO) * outAmplitude,
        py - sin(angO) * outAmplitude,
        px + cos(angI) * inAmplitude,
        py - sin(angI) * inAmplitude,
        outputBezier.length()
    )
}

func getPerpendicularVector(pt1: PointF, pt2: PointF): Array<Float64> {
    let vector: Array<Float64> = [
        pt2.x - pt1.x,
        pt2.y - pt1.y
    ]
    let rot: Float64 = -Float64.PI * 0.5
    let rotatedVector: Array<Float64> = [
      cos(rot) * vector[0] - sin(rot) * vector[1],
      sin(rot) * vector[0] + cos(rot) * vector[1]
    ]
    return rotatedVector
}

func getProjectingAngle(path: ShapeData, cur: Int64): Float64 {
    var prevIndex: Int64 = cur - 1
    if (cur == 0) {
        prevIndex = path.length() - 1
    }
    let nextIndex: Int64 = (cur + 1) % path.length()
    let prevPoint: PointF = path.v[prevIndex]
    let nextPoint: PointF = path.v[nextIndex]
    let pVector: Array<Float64> = getPerpendicularVector(prevPoint, nextPoint)
    /**
     * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
     * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
     * atan2(p[1], p[0]) = atan(p[1] / p[0])
     * 注意 0/1 ，0 作为除数。
     */
    return atan(0.0 / 1.0) - atan(pVector[1] / pVector[0])
}

func zigZagCorner(outputBezier: ShapeData, path: ShapeData, cur: Int64, amplitude: Float64, 
                    frequency: Float64, pointType: Float64, direction: Float64
): Unit {
    var angle: Float64 = getProjectingAngle(path, cur)
    var point: PointF = path.v[cur % path._length]

    var index: Int64 = cur - 1
    if (cur == 0) {
        index = path._length - 1
    }
    let prevPoint: PointF = path.v[index]
    
    let nextPoint: PointF = path.v[(cur + 1) % path._length]

    var prevDist: Float64 = 0.0
    if (pointType == 2.0) {
        prevDist = sqrt(pow(point.x - prevPoint.x, 2) + pow(point.y - prevPoint.y, 2))
    }

    var nextDist: Float64 = 0.0
    if (pointType == 2.0) {
        nextDist = sqrt(pow(point.x - nextPoint.x, 2) + pow(point.y - nextPoint.y, 2))
    }
    
    setPoint(
        outputBezier,
        path.v[cur % path._length],
        angle,
        direction,
        amplitude,
        nextDist / ((frequency + 1.0) * 2.0),
        prevDist / ((frequency + 1.0) * 2.0)
    )
}

func zigZagSegment(outputBezier: ShapeData, segment: PolynomialBezier, amplitude: Float64, frequency: Int64, pointType: Float64, direction2: Float64) {
    var direction: Float64 = direction2
    for (i in 0..frequency) {
        var t: Float64 = Float64((i + 1) / (frequency + 1))

        var dist: Float64 = 0.0
        if (pointType == 2.0) {
            dist = sqrt(pow(segment.points[3][0] - segment.points[0][0], 2) + pow(segment.points[3][1] - segment.points[0][1], 2))
        }
    
        let angle: Float64 = segment.normalAngle(t)
        let point: Array<Float64> = segment.point(t)
        setPoint(
            outputBezier,
            point,
            angle,
            direction,
            amplitude,
            dist / ((Float64(frequency) + 1.0) * 2.0),
            dist / ((Float64(frequency) + 1.0) * 2.0)
        )

        direction = -direction
    }

    return direction
}
