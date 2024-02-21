/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class GradientFill {

    /**
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFillParser
     */
    var nm: String = ""                                                   //0 = name

    // "g": {"p": points/Int64, "k": color/ArrayList<Keyframe<T>>}
    var g: ContentModelP = ContentModelP()                                //1 = {points, color}

    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()      //2 = opacity
    var t: Int64 = 0                                                      //3 = gradientType
    var s: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //4 = startPoint
    var e: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //5 = endPoint
    var r: Int64 = 0                                                      //6 = fillTypeInt
    var hd: Bool = false                                                  //7 = hidden

    init(){}
}