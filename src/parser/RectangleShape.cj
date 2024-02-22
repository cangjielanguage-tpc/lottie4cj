/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class RectangleShape <: ContentModel {

    /**
     * 8. "layers"."shapes".{"ty": "rc"} = RectangleShapeParser
     */
    var nm: String = ""                              // 0 = name
    var p: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()   // 1 = position
    var s: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()               // 2 = size
    var r: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()             // 3 = roundedness
    var hd: Bool = false                             // 4 = hidden

    let ty: String = "rc"

    init(){}

    public override prop types: Int8 {
        get() { 8 }
    }

    public func toString(): String {
        return "RectangleShape[rc]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "p = ${p} \n" +
               "s = ${s} \n" +
               "r = ${r} \n" +
               "hd = ${hd} \n}"
    }
}
