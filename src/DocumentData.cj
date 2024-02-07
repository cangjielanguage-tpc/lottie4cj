/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file
 * The file declars the LottiePlayer class.
 */
package lottie4cj

public class DocumentData {

    //"layers"."t"."d"
    var t: String = ""  // 0  = text
    var f: String  = "" // 1  = fontName
    var s: Float64 = 0.0  // 2  = size
    var j: Int64 = 0    // 3  = justification
    var tr: Int64 = 0   // 4  = tracking
    var lh: Float64 = 0.0 // 5  = lineHeight
    var ls: Float64 = 0.0 // 6  = baselineShift
    var fc: Array<Int64> = Array<Int64>() // 7  = fillColor
    var sc: Array<Int64> = Array<Int64>() // 8  = strokeColor
    var sw: Float64 = 0.0       // 9  = strokeWidth
    var of: Bool = false      // 10 = strokeOverFill
    var ps: PointF = PointF()  // 11 = boxPosition
    var sz: PointF = PointF()  // 12 = boxSize

    init(){}
}
