/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableTextPropertiesA <: ToString {

    var a: AnimatableTextProperties = AnimatableTextProperties()

    init(){}
    init (a: AnimatableTextProperties){
        this.a = a
    }

    public func toString(): String {
        return "AnimatableTextPropertiesA: { a = ${a} }"
    }
}

public class AnimatableTextProperties <: ToString {

    var fc: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()                       //0 = color

    var sc: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()   //1 = stroke
    var sw: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()                 //2 = strokeWidth

    var t: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()                                  //3 = tracking

    init(){}

    public func toString(): String {
        return "AnimatableTextProperties: {\n" +
               "fc = ${fc},\n" +
               "sc = ${sc},\n" +
               "sw = ${sw},\n" +
               "t = ${t} \n}"
    }
}
