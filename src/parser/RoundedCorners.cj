/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class RoundedCorners <: ContentModel {

    /**
     * 13. "layers"."shapes".{"ty": "rd"} = RoundedCornersParser
     */
    var nm: String = ""                                                   // 0
    var r: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  // 1
    var hd: Bool = false                                                  // 2

    let ty: String = "rd"

    init(){}

    public override prop types: Int8 {
        get() { 13 }
    }

    public func toString(): String {
        return "RoundedCorners[rd]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "r = ${r} \n" +
               "hd = ${hd} \n}"
    }
}
