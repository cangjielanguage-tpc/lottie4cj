/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is handle ShapeData.
 */
package lottie4cj.inner

internal import lottie4cj.model.*
internal import lottie4cj.bezier.*

/**
 * Build shape string.
 *
 * @param pathNodes - Type of ShapeData.
 * @param length - Type of Int64.
 * @param closed - Type of Bool.
 * @param mat - Type of Matrix, the value of mat.
 * @return Type of String, converted String.
 */
public func buildShapeString(pathNodes: ShapeData, length: Int64, closed: Bool, mat: Matrix): String {
    if (length == 0) {
        return ""
    }
    let _o: Array<PointF> = pathNodes.o
    let _i: Array<PointF> = pathNodes.i
    let _v: Array<PointF> = pathNodes.v
    var i: Int64 = 1
    var shapeString = " M" + mat.applyToPointStringified(_v[0].x, _v[0].y)
    while (i < length) {
        shapeString += " C" + mat.applyToPointStringified(_o[i - 1].x, _o[i - 1].y) + " " + mat.applyToPointStringified(_i[i].x, _i[i].y) + " " + mat.applyToPointStringified(_v[i].x, _v[i].y)
        i++
    }
    if (closed && length != 0) {
        shapeString += " C" + mat.applyToPointStringified(_o[i - 1].x, _o[i - 1].y) + " " + mat.applyToPointStringified(_i[0].x, _i[0].y) + " " + mat.applyToPointStringified(_v[0].x, _v[0].y)
        shapeString += "z"
    }
    return shapeString
}