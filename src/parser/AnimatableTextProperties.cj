/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableTextProperties <: ToString {

    var fc: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>() //0 = color
    var sc: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>() //1 = stroke
    var sw: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()               //2 = strokeWidth
    var t: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()                //3 = tracking

    init(){}

    public func toString(): String {
        return "AnimatableTextProperties: {\n" +
               "fc = ${fc},\n" +
               "sc = ${sc},\n" +
               "sw = ${sw},\n" +
               "t = ${t} \n}"
    }
}
