/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is bez.
 */
package utils

func defaultFnct(num: Float64): Int64 {
    return 0
}

class KeyframeMetadata {
    var bezierData: BezierData = BezierData()

    var __fnct: Option<(Int64) -> Int64> = None
    init(){}
    func isNull(): Bool {
        return bezierData.isNull()
    }
}

public class BezierData {
    var segmentLength: Int64 = 0
    var points: Array<PointData> = Array<PointData>()

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
        this.points = Array<PointData>(len, item: empty)
    }

    /**
     * Create a BezierData instance based on parameters.
     *
     * @param segmentLength - Type of Int64, the segmentLength value.
     * @param points - Type of Array<PointData>, the points value.
     */
    public init(segmentLength: Int64, points: Array<PointData>){
        this.segmentLength = segmentLength
        this.points = points
    }

    /**
     * Determine if the current BezierData is null.
     *
     * @return Type of Bool, returns the result of determine if the current BezierData is null.
     */
    public func isNull(): Bool {
        return segmentLength <= 0 && points.size == 0
    }
}

public class PointData {
    var partialLength: Int64 = 0
    var point: Array<Float64> = Array<Float64>()

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

//TODO: 未完全开发
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
        let dist1: Float64 = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2) + math.pow(z2 - z1, 2))
        let dist2: Float64 = math.sqrt(math.pow(x3 - x1, 2) + math.pow(y3 - y1, 2) + math.pow(z3 - z1, 2))
        let dist3: Float64 = math.sqrt(math.pow(x3 - x2, 2) + math.pow(y3 - y2, 2) + math.pow(z3 - z2, 2))
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

    
    //TODO: 未开发 getBezierLength
    //TODO: 未开发 getSegmentsLength
    //TODO: 未开发 BezierData
    //TODO: 未开发 PointData
    
    /**
     * Building Bezier data.
     *
     * @return Type of (Array<Float64>, Array<Float64>, Array<Float64>, Array<Float64>) -> BezierData.
     */
    public static func buildBezierData(): (Array<Float64>, Array<Float64>, Array<Float64>, Array<Float64>) -> BezierData {

        let storedData: HashMap<String, BezierData> = HashMap<String, BezierData>(24)

        func inside(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>): BezierData {
            //TODO: pt1/pt2/pt3/pt4 会出现数组长度小于2吗？
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
                        ptCoord = math.pow(1.0 - perc, 3) * pt1[i] + 3.0 * math.pow(1.0 - perc, 2) * perc * (pt1[i] + pt3[i]) +
                            3.0 * (1.0 - perc) * math.pow(perc, 2) * (pt2[i] + pt4[i]) + math.pow(perc, 3) * pt2[i]
                        point[i] = ptCoord
                        if (lastPoint.size > 0) {
                            ptDistance += math.pow(point[i] - lastPoint[i], 2)
                        }
                    }
                    ptDistance = math.sqrt(ptDistance)
                    addedLength += ptDistance
                    bezierData.points[k] = PointData(Int64(ptDistance), point)
                    lastPoint = point
                }
                bezierData.segmentLength = Int64(addedLength)
                storedData.put(bezierName, bezierData)
            }
            return storedData[bezierName]
        }
        return inside
    }
    
    //TODO: 未开发 getDistancePerc
    //TODO: 未开发 getPointInSegment
    //TODO: 未开发 bezierSegmentPoints
    //TODO: 未开发 getNewSegment

}


