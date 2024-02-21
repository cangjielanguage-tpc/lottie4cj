/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package lottie4cj

public class GradientStroke {

    /**
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStrokeParser
     */
    var nm: String = ""                                                   //0 = name

    // "g": {"p": points/Int64, "k": color/ArrayList<Keyframe<T>>}
    var g: ContentModelP = ContentModelP()                                //1 = {points, color}

    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()      //2 = opacity
    var t: Int64 = 0                                                      //3 = gradientType
    var s: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //4 = startPoint
    var e: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()    //5 = endPoint
    var w: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  //6 = width
    var lc: Int64 = 0                                                     //7 = capType
    var lj: Int64 = 0                                                     //8 = joinType
    var ml: Float64 = 0.0                                                   //9 = miterLimit
    var hd: Bool = false                                                  //10 = hidden

    //"d": [{"n": "String", "v": ArrayList<Keyframe<Float64>>}]  ==  ArrayList<ContentModelD>
    var d: ArrayList<ContentModelD> = ArrayList<ContentModelD>()          //11 = lineDashPattern

    init(){}
}
