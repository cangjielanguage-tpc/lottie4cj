/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class DocumentData <: ToString {

    //"layers"."t"."d"
    var t: String = ""         // 0  = text
    var f: String  = ""        // 1  = fontName
    var s: Float64 = 0.0       // 2  = size
    var j: Int64 = 0           // 3  = justification
    var tr: Int64 = 0          // 4  = tracking
    var lh: Float64 = 0.0      // 5  = lineHeight
    var ls: Float64 = 0.0      // 6  = baselineShift
    var fc: Array<Float64> = Array<Float64>()   // 7  = fillColor
    var sc: Array<Float64> = Array<Float64>()   // 8  = strokeColor
    var sw: Float64 = 0.0      // 9  = strokeWidth
    var of: Bool = false       // 10 = strokeOverFill
    var ps: PointF = PointF()  // 11 = boxPosition
    var sz: PointF = PointF()  // 12 = boxSize

    init(){}

    public func toString(): String {
        return "DocumentData: { \n" +
               "t = ${t} \n" +
               "f = ${f} \n" +
               "s = ${s} \n" +
               "j = ${j} \n" +
               "tr = ${tr} \n" +
               "lh = ${lh} \n" +
               "ls = ${ls} \n" +
               "fc = ${fc} \n" +
               "sc = ${sc} \n" +
               "sw = ${sw} \n" +
               "of = ${of} \n" +
               "ps = ${ps} \n" +
               "sz = ${sz} \n" +
               "}"
    }
}
