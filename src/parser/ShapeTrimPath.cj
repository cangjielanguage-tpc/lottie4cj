/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapeTrimPath <: ContentModel {

    /**
     * 9. "layers"."shapes".{"ty": "tm"} = ShapeTrimPathParser
     */
    var s: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()    // 0 = start
    var e: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()    // 1 = end
    var o: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()    // 2 = offset
    var nm: String = ""                                                     // 3 = name
    var m: Int64 = 0                                                        // 4 = type
    var hd: Bool = false                                                    // 5 = hidden

    let ty: String = "tm"

    init(){}

    public override prop types: Int8 {
        get() { 9 }
    }

    public func toString(): String {
        return "ShapeTrimPath[tm]: { \n" +
               "ty = ${ty} \n" +
               "s = ${s} \n" +
               "e = ${e} \n" +
               "o = ${o} \n" +
               "nm = ${nm} \n" +
               "m = ${m} \n" +
               "hd = ${hd} \n}"
    }
}
