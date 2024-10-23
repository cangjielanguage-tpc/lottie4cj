/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is bez.
 */
//package lottie.utils
//package lottie.bezier
package lottie.pool

internal import lottie.inner.*
//internal import lottie.pool.*
//internal import lottie.model.*

internal import std.math.*
internal import std.collection.*

func defaultFnct(num: Float64): Int64 {
    return 0
}

public class KeyframeMetadata {
    public var bezierData: BezierData = BezierData()

    //TODO: 是否考虑把 __fnct 从 Option 改为 Array？？？
    //var __fnct: Option<(Float64) -> Int64> = None
    public var __fnct: Option<(Float64) -> Float64> = None
    public init(){}
    public func isNull(): Bool {
        return bezierData.isNull()
    }
}


//class StoredData {
//    var bezierName: BezierData = BezierData()
//    init(){}
//    func isNull(): Bool {
//        return bezierName.isNull()
//    }
//}
public class BezierData {
    public var segmentLength: Float64 = 0.0
    public var points: Array<PointData> = Array<PointData>()

    /**
     * Create a BezierData instance.
     */
    public init(){}

    /**
     * Create a BezierData instance based on parameters.
     *
     * @param len - Type of Int64, the points array length.
     * @param empty - Type of PointData, the points array type.
     */
    public init(len: Int64, empty: PointData){
        if (len < 0) {
            throw IllegalArgumentException("The length of points cannot be negative.")
        }
        this.points = Array<PointData>(len, item: empty)
    }

    /**
     * Create a BezierData instance based on parameters.
     *
     * @param segmentLength - Type of Float64, the segmentLength value.
     * @param points - Type of Array<PointData>, the points value.
     */
    public init(segmentLength: Float64, points: Array<PointData>){
        this.segmentLength = segmentLength
        this.points = points
    }

    /**
     * Determine if the current BezierData is null.
     *
     * @return Type of Bool, returns the result of determine if the current BezierData is null.
     */
    public func isNull(): Bool {
        return segmentLength <= 0.0 && points.size == 0
    }
}

public class PointData {
    public var partialLength: Int64 = 0
    public var point: Array<Float64> = Array<Float64>()

    /**
     * Create a PointData instance.
     */
    public init(){}
    
    /**
     * Create a PointData instance based on parameters.
     *
     * @param partialLength - Type of Int64, the partialLength value.
     * @param point - Type of Array<Float64>, the point value.
     */
    public init(partialLength: Int64, point: Array<Float64>){
        this.partialLength = partialLength
        this.point = point
    }
}

public class Bez {

    static let defaultCurveSegments: Int64 = 150

    /**
     * Check if the points is on the 2D line.
     *
     * @param x1 - Type of Float64.
     * @param y1 - Type of Float64.
     * @param x2 - Type of Float64.
     * @param y2 - Type of Float64.
     * @param x3 - Type of Float64.
     * @param y3 - Type of Float64.
     * @return Type of Bool, result value.
     */
    public static func pointOnLine2D(x1: Float64, y1: Float64, x2: Float64, y2: Float64, x3: Float64, y3: Float64): Bool {
        let det1: Float64 = (x1 * y2) + (y1 * x3) + (x2 * y3) - (x3 * y2) - (y3 * x1) - (x2 * y1)
        return det1 > -0.001 && det1 < 0.001
    }

    /**
     * Check if the points is on the 3D line.
     *
     * @param x1 - Type of Float64.
     * @param y1 - Type of Float64.
     * @param z1 - Type of Float64.
     * @param x2 - Type of Float64.
     * @param y2 - Type of Float64.
     * @param z2 - Type of Float64.
     * @param x3 - Type of Float64.
     * @param y3 - Type of Float64.
     * @param z3 - Type of Float64.
     * @return Type of Bool, result value.
     */
    public static func pointOnLine3D(x1: Float64, y1: Float64, z1: Float64, x2: Float64, y2: Float64, z2: Float64, x3: Float64, y3: Float64, z3: Float64): Bool {
        if (z1 == 0.0 && z2 == 0.0 && z3 == 0.0) {
            return pointOnLine2D(x1, y1, x2, y2, x3, y3)
        }
        let dist1: Float64 = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2))
        let dist2: Float64 = sqrt(pow(x3 - x1, 2) + pow(y3 - y1, 2) + pow(z3 - z1, 2))
        let dist3: Float64 = sqrt(pow(x3 - x2, 2) + pow(y3 - y2, 2) + pow(z3 - z2, 2))
        var diffDist: Float64 = 0.0
        if (dist1 > dist2) {
            if (dist1 > dist3) {
                diffDist = dist1 - dist2 - dist3
            } else {
                diffDist = dist3 - dist2 - dist1
            }
        } else if (dist3 > dist2) {
            diffDist = dist3 - dist2 - dist1
        } else {
            diffDist = dist2 - dist1 - dist3
        }
        return diffDist > -0.0001 && diffDist < 0.0001
    }

    static func getBezierLength(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>): BezierLengthElement {
        var curveSegments: Int64 = getDefaultCurveSegments()

        var ptCoord: Float64 = 0.0
        var perc: Float64 = 0.0
        var addedLength: Float64 = 0.0
        var ptDistance: Float64 = 0.0
        var point: Array<Float64> = Array<Float64>()
        var lastPoint: Array<Float64> = Array<Float64>()
        //TODO:  数据类型  Element<Float64>  更换为  BezierLengthElement
        let lengthData: BezierLengthElement = BezierLengthElement()
        let len: Int64 = pt3.size
        for (k in 0..curveSegments) {
            perc = Float64(k / (curveSegments - 1))
            ptDistance = 0.0
            for (i in 0..len) {
                ptCoord = pow(1.0 - perc, 3) * pt1[i] + 3.0 * pow(1.0 - perc, 2) * perc * pt3[i] + 
                        3.0 * (1.0 - perc) * pow(perc, 2) * pt4[i] + pow(perc, 3) * pt2[i]
                point[i] = ptCoord
                if (lastPoint.size > i) {
                    ptDistance += pow(point[i] - lastPoint[i], 2)
                }
                lastPoint[i] = point[i]
            }
            if (ptDistance != 0.0) {
                ptDistance = sqrt(ptDistance)
                addedLength += ptDistance
            }
            lengthData.percents[k] = perc
            lengthData.lengths[k] = addedLength
        }
        lengthData.addedLength = Int64(addedLength)
        return lengthData
    }

    public static func getSegmentsLength(shapeData: ShapeData): SegmentsLengthElement {
        //TODO: 数据类型 Element<Element> 更换为 SegmentsLengthElement。
        var segmentsLength: SegmentsLengthElement =SegmentsLengthElement()
        
        var closed: Bool = shapeData.c
        var pathV: Array<PointF> = shapeData.v
        var pathO: Array<PointF> = shapeData.o
        var pathI: Array<PointF> = shapeData.i

        var len = shapeData._length
        
        var lengths: Array<BezierLengthElement> = segmentsLength.lengths
        var totalLength: Int64 = 0
        for (i in 0..(len - 1)) {
            lengths[i] = getBezierLength([pathV[i].x, pathV[i].y], [pathV[i + 1].x, pathV[i + 1].y], [pathO[i].x, pathO[i].y], [pathI[i + 1].x, pathI[i + 1].y])
            totalLength += lengths[i].addedLength
        }
        let i: Int64 = len - 1
        if (closed && len != 0) {
            lengths[i] = getBezierLength([pathV[i].x, pathV[i].y], [pathV[0].x, pathV[0].y], [pathO[i].x, pathO[i].y], [pathI[0].x, pathI[0].y])
            totalLength += lengths[i].addedLength
        }
        segmentsLength.totalLength = totalLength
        return segmentsLength
    }

    static func getBezierData(length: Int64): BezierData {
        let bd: BezierData = BezierData()
        bd.segmentLength = 0.0
        bd.points = Array<PointData>(length, item: PointData())
        return bd
    }

    static func getPointData(partial: Int64, point: Array<Float64>): PointData {
        return PointData(partial, point)
    }

    static let storedData: HashMap<String, BezierData> = HashMap<String, BezierData>(24)

    public static func buildBezierData(pt1: PointF, pt2: PointF, pt3: PointF, pt4: PointF): BezierData {
        return buildBezierData([pt1.x, pt1.y], [pt2.x, pt2.y], [pt3.x, pt3.y], [pt4.x, pt4.y])
    }

    public static func buildBezierData(pt1: PointF, pt2: PointF, pt3: Array<Float64>, pt4: Array<Float64>): BezierData {
        return buildBezierData([pt1.x, pt1.y], [pt2.x, pt2.y], pt3, pt4)
    }

    //public static func buildBezierData(): (Array<Float64>, Array<Float64>, Array<Float64>, Array<Float64>) -> BezierData {
    public static func buildBezierData(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>): BezierData {
        //TODO：此处的 storedData 无用。需要调整此函数。
        //let storedData: HashMap<String, BezierData> = HashMap<String, BezierData>(24)

        //func inside(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>): BezierData {
            if (pt1.size < 2 || pt2.size < 2 || pt3.size < 2 || pt4.size < 2) {
                throw IndexOutOfBoundsException("[buildBezierData]: pt1.size = ${pt1.size}, pt2.size = ${pt2.size}, pt3.size = ${pt3.size}, pt4.size = ${pt4.size}")
            }
            let key: String = pt1[0].toString() + "_" + pt1[1].toString() + "_" +
                pt2[0].toString() + "_" + pt2[1].toString() + "_" + pt3[0].toString() + "_" + pt3[1].toString() + "_" +
                pt4[0].toString() + "_" + pt4[1].toString()
            let bezierName: String = key.replace(".", "p")
            if (!storedData.contains(bezierName)) {
                var curveSegments: Int64 = defaultCurveSegments

                var ptCoord: Float64 = 0.0
                var perc: Float64 = 0.0
                var addedLength: Float64 = 0.0
                var ptDistance: Float64 = 0.0
                var point: Array<Float64> = Array<Float64>()
                var lastPoint: Array<Float64> = Array<Float64>()
                if (pt1.size == 2 && (pt1[0] != pt2[0] || pt1[1] != pt2[1]) &&
                    pointOnLine2D(pt1[0], pt1[1], pt2[0], pt2[1], pt1[0] + pt3[0], pt1[1] + pt3[1]) &&
                    pointOnLine2D(pt1[0], pt1[1], pt2[0], pt2[1], pt2[0] + pt4[0], pt2[1] + pt4[1])
                ) {
                    curveSegments = 2
                }
                let empty: PointData = PointData()
                var bezierData = BezierData(curveSegments, empty)
                let len: Int64 = pt3.size
                for (k in 0..curveSegments) {
                    point = Array<Float64>(len, item: 0.0)
                    perc = Float64(k / (curveSegments - 1))
                    ptDistance = 0.0
                    for (i in 0..len) {
                        ptCoord = pow(1.0 - perc, 3) * pt1[i] + 3.0 * pow(1.0 - perc, 2) * perc * (pt1[i] + pt3[i]) +
                            3.0 * (1.0 - perc) * pow(perc, 2) * (pt2[i] + pt4[i]) + pow(perc, 3) * pt2[i]
                        point[i] = ptCoord
                        if (lastPoint.size > 0) {
                            ptDistance += pow(point[i] - lastPoint[i], 2)
                        }
                    }
                    ptDistance = sqrt(ptDistance)
                    addedLength += ptDistance
                    bezierData.points[k] = PointData(Int64(ptDistance), point)
                    lastPoint = point
                }
                bezierData.segmentLength = addedLength
                storedData.put(bezierName, bezierData)
            }
            return storedData[bezierName]
        //}
        //return inside
    }

    static func getDistancePerc(perc: Int64, bezierData: BezierLengthElement): Float64 {
        let percents: Array<Float64> = bezierData.percents
        let lengths: Array<Float64> = bezierData.lengths
        let len: Int64 = percents.size
        var initPos: Int64 = Int64(floor(Float64((len - 1) * perc)))
        let lengthPos: Float64 = Float64(perc * bezierData.addedLength)
        var lPerc: Float64 = 0.0
        if (initPos == len - 1 || initPos == 0 || lengthPos == lengths[initPos]) {
            return percents[initPos]
        }

        var dir: Int64 = 1
        if (lengths[initPos] > lengthPos) {
            dir = -1
        }
        
        var flag: Bool = true
        while (flag) {
            if (lengths[initPos] <= lengthPos && lengths[initPos + 1] > lengthPos) {
                lPerc = (lengthPos - lengths[initPos]) / (lengths[initPos + 1] - lengths[initPos])
                flag = false
            } else {
                initPos += dir
            }
            if (initPos < 0 || initPos >= len - 1) {
                //FIX用于不能以足够的精度存储浮点值的TypedArray
                if (initPos == len - 1) {
                    return percents[initPos]
                }
                flag = false
            }
        }
        return percents[initPos] + (percents[initPos + 1] - percents[initPos]) * lPerc
    }

    public static func getPointInSegment(pt1: PointF, pt2: PointF, pt3: PointF, pt4: PointF, percent: Int64, bezierData: BezierLengthElement): Array<Float64> {
        return getPointInSegment([pt1.x, pt1.y], [pt2.x, pt2.y], [pt3.x, pt3.y], [pt4.x, pt4.y], percent, bezierData)
    }
    
    public static func getPointInSegment(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>, percent: Int64, bezierData: BezierLengthElement): Array<Float64> {
        let t1: Float64 = getDistancePerc(percent, bezierData)
        let u1: Float64 = 1.0 - t1
        let ptX: Float64 = round((u1 * u1 * u1 * pt1[0] + (t1 * u1 * u1 + u1 * t1 * u1 + u1 * u1 * t1) * pt3[0] + (t1 * t1 * u1 + u1 * t1 * t1 + t1 * u1 * t1) * pt4[0] + t1 * t1 * t1 * pt2[0]) * 1000.0) / 1000.0
        let ptY: Float64 = round((u1 * u1 * u1 * pt1[1] + (t1 * u1 * u1 + u1 * t1 * u1 + u1 * u1 * t1) * pt3[1] + (t1 * t1 * u1 + u1 * t1 * t1 + t1 * u1 * t1) * pt4[1] + t1 * t1 * t1 * pt2[1]) * 1000.0) / 1000.0
        return [ptX, ptY]
    }

    public static func getNewSegment(pt1: PointF, pt2: PointF, pt3: PointF, pt4: PointF, startPerc2: Int64, endPerc2: Int64, bezierData: BezierLengthElement): Array<Float64> {
        return getNewSegment([pt1.x, pt1.y], [pt2.x, pt2.y], [pt3.x, pt3.y], [pt4.x, pt4.y], startPerc2, endPerc2, bezierData)
    }
    
    public static func getNewSegment(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>, startPerc2: Int64, endPerc2: Int64, bezierData: BezierLengthElement): Array<Float64> {
        var startPerc: Int64 = startPerc2
        var endPerc: Int64 = endPerc2
        if (startPerc < 0) {
            startPerc = 0
        } else if (startPerc > 1) {
            startPerc = 1
        }

        let t0: Float64 = getDistancePerc(startPerc, bezierData)
        if (endPerc > 1) {
            endPerc = 1
        } else {
            endPerc = endPerc
        }

        let t1: Float64 = getDistancePerc(endPerc, bezierData)

        
        let u0: Float64 = 1.0 - t0
        let u1: Float64 = 1.0 - t1
        let u0u0u0: Float64 = u0 * u0 * u0
        let t0u0u0_3: Float64 = t0 * u0 * u0 * 3.0 // eslint-disable-line camelcase
        let t0t0u0_3: Float64 = t0 * t0 * u0 * 3.0 // eslint-disable-line camelcase
        let t0t0t0: Float64 = t0 * t0 * t0

        let u0u0u1: Float64 = u0 * u0 * u1
        let t0u0u1_3: Float64 = t0 * u0 * u1 + u0 * t0 * u1 + u0 * u0 * t1 // eslint-disable-line camelcase
        let t0t0u1_3: Float64 = t0 * t0 * u1 + u0 * t0 * t1 + t0 * u0 * t1 // eslint-disable-line camelcase
        let t0t0t1: Float64 = t0 * t0 * t1

        let u0u1u1: Float64 = u0 * u1 * u1
        let t0u1u1_3: Float64 = t0 * u1 * u1 + u0 * t1 * u1 + u0 * u1 * t1 // eslint-disable-line camelcase
        let t0t1u1_3: Float64 = t0 * t1 * u1 + u0 * t1 * t1 + t0 * u1 * t1 // eslint-disable-line camelcase
        let t0t1t1: Float64 = t0 * t1 * t1

        let u1u1u1: Float64 = u1 * u1 * u1
        let t1u1u1_3: Float64 = t1 * u1 * u1 + u1 * t1 * u1 + u1 * u1 * t1 // eslint-disable-line camelcase
        let t1t1u1_3: Float64 = t1 * t1 * u1 + u1 * t1 * t1 + t1 * u1 * t1 // eslint-disable-line camelcase
        let t1t1t1: Float64 = t1 * t1 * t1
        
        let bezierSegmentPoints: Array<Float64> = Array<Float64>(8, item: 0.0)
        let len: Int64 = pt1.size
        for (i in 0..len) {
            bezierSegmentPoints[i * 4] = round((u0u0u0 * pt1[i] + t0u0u0_3 * pt3[i] + t0t0u0_3 * pt4[i] + t0t0t0 * pt2[i]) * 1000.0) / 1000.0 // eslint-disable-line camelcase
            bezierSegmentPoints[i * 4 + 1] = round((u0u0u1 * pt1[i] + t0u0u1_3 * pt3[i] + t0t0u1_3 * pt4[i] + t0t0t1 * pt2[i]) * 1000.0) / 1000.0 // eslint-disable-line camelcase
            bezierSegmentPoints[i * 4 + 2] = round((u0u1u1 * pt1[i] + t0u1u1_3 * pt3[i] + t0t1u1_3 * pt4[i] + t0t1t1 * pt2[i]) * 1000.0) / 1000.0 // eslint-disable-line camelcase
            bezierSegmentPoints[i * 4 + 3] = round((u1u1u1 * pt1[i] + t1u1u1_3 * pt3[i] + t1t1u1_3 * pt4[i] + t1t1t1 * pt2[i]) * 1000.0) / 1000.0 // eslint-disable-line camelcase
        }

        return bezierSegmentPoints
    }

}
