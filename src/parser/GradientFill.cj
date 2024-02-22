/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class GradientFill <: ContentModel {

    /**
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFillParser
     */
    var nm: String = ""                                                   //0 = name

    // "g": {"p": points/Int64, "k": color/ArrayList<Keyframe<T>>}  => ArrayList<Keyframe<Array<Float64>>>
    var g: ContentModelP = ContentModelP()                                //1 = {points, color}

    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()      //2 = opacity
    var t: Int64 = 0                                                      //3 = gradientType
    var s: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //4 = startPoint
    var e: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //5 = endPoint
    var r: Int64 = 0                                                      //6 = fillTypeInt
    var hd: Bool = false                                                  //7 = hidden

    let ty: String = "gf"

    init(){}

    public override prop types: Int8 {
        get() { 4 }
    }

    public func toString(): String {
        return "GradientFill[gf]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "g = ${g} \n" +
               "o = ${o} \n" +
               "t = ${t} \n" +
               "s = ${s} \n" +
               "e = ${e} \n" +
               "r = ${r} \n" +
               "hd = ${hd} \n}"
    }
}
