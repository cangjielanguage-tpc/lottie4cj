/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapeFill <: ContentModel {

    /**
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
     */
    var nm: String = ""                     // 0 = name
    var c: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()  // 1 = color
    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()                    // 2 = opacity
    var fillEnabled: Bool = false           // 3 = fillEnabled
    var r: Int64 = 0                        // 4 = fillTypeInt
    var hd: Bool = false                    // 5 = hidden

    let ty: String = "fl"

    init(){}

    public override prop types: Int8 {
        get() { 3 }
    }

    public func toString(): String {
        return "ShapeFill[fl]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "c = ${c} \n" +
               "o = ${o} \n" +
               "fillEnabled = ${fillEnabled} \n" +
               "r = ${r} \n" +
               "hd = ${hd} \n}"
    }
}
