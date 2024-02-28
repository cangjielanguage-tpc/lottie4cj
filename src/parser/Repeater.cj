/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Repeater <: ContentModel {

    /**
     * 12. "layers"."shapes".{"ty": "rp"} = RepeaterParser
     */
    var nm: String = ""                                                          // 0 = name
    var c: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()         // 1 = copies
    var o: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()         // 2 = offset

    var tr: AnimatableTransform = AnimatableTransform()                          // 3 = transform
    var hd: Bool = false                                                         // 4 = hidden

    let ty: String = "rp"

    init(){}

    public override prop types: Int8 {
        get() { 12 }
    }

    public func toString(): String {
        return "Repeater[rp]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "c = ${c} \n" +
               "o = ${o} \n" +
               "tr = ${tr} \n" +
               "hd = ${hd} \n}"
    }
}
