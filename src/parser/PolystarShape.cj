/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class PolystarShape <: ContentModel {

    /**
     * 10. "layers"."shapes".{"ty": "sr"} = PolystarShapeParser
     */
    var nm: String = ""              // 0  = name
    var sy: Int64 = 0                // 1  = type
    var pt: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()           // 2  = points
    var p: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()  // 3  = position
    var r: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()            // 4  = rotation
    var or: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()           // 5  = outerRadius
    var os: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()           // 6  = outerRoundedness
    var ir: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()           // 7  = innerRadius

    var is2: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()          // 8  = innerRoundedness
    var hd: Bool = false             // 9  = hidden
    var d: Int64 = 0                 // 10 = reversed

    let ty: String = "sr"

    init(){}

    public override prop types: Int8 {
        get() { 10 }
    }

    public func toString(): String {
        return "PolystarShape[sr]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "sy = ${sy} \n" +
               "pt = ${pt} \n" +
               "p = ${p} \n" +
               "r = ${r} \n" +
               "or = ${or} \n" +
               "os = ${os} \n" +
               "ir = ${ir} \n" +
               "is2 = ${is2} \n" +
               "hd = ${hd} \n" +
               "d = ${d} \n}"
    }
}
