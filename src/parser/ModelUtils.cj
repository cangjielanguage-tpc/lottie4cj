/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser


public class ArrayKeyframeArrayFloat64 <: ToString {

    var k: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

    init(){}
    init (k: ArrayList<Keyframe<Array<Float64>>>){
        this.k = k
    }

    public func toString(): String {
        return "ArrayKeyframeArrayFloat64: { k = ${k} }"
    }
}

public class ArrayKeyframeFloat64 <: ToString {
    var k: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

    init(){}
    init (k: ArrayList<Keyframe<Float64>>){
        this.k = k
    }

    public func toString(): String {
        return "ArrayKeyframeFloat64: { k = ${k} }"
    }
}
