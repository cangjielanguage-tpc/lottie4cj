/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapeStroke <: ContentModel {

    /**
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStrokeParser
     */
    var nm: String = ""                                                                // 0 = name
    var c: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>() // 1 = color
    var w: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  // 2 = width
    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()      // 3 = opacity
    var lc: Int64 = 0                                                     // 4 = capType
    var lj: Int64 = 0                                                     // 5 = joinType
    var ml: Float64 = 0.0                                                 // 6 = miterLimit
    var hd: Bool = false                                                  // 7 = hidden
    var d: ArrayList<ContentModelD> = ArrayList<ContentModelD>()          // 8 = lineDashPattern
    //"d": [{"n": "String "v": ArrayList<Keyframe<T>>}]

    let ty: String = "st"

    init(){}

    public override prop types: Int8 {
        get() { 1 }
    }

    public func toString(): String {
        return "ShapeStroke[st]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "c = ${c} \n" +
               "w = ${w} \n" +
               "o = ${o} \n" +
               "lc = ${lc} \n" +
               "lj = ${lj} \n" +
               "ml = ${ml} \n" +
               "hd = ${hd} \n" +
               "d = ${d} \n}"
    }

}
