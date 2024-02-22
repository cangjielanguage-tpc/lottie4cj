/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public open class ContentModel <: ToString {

    public open prop types: Int8 {
        get() { -1 }
    }

    public open func toString(): String { "The ContentModel is None." }
}

// "g": {"p": points/Int64, "k": color/ArrayList<Keyframe<T>>}
public open class ContentModelP <: ToString {

    var p: Int64 = 0
    var k: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

    init(p!: Int64 = 0, k!: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()){
        this.p = p
        this.k = k
    }

    public func toString(): String {
        return "ContentModelP: { \n" +
               "p = ${p},\n" +
               "k = ${k} \n}"
    }
}

//"d": [{"n": "String "v": ArrayList<Keyframe<T>>}]
public open class ContentModelD <: ToString {

    var n: String = ""
    var v: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

    init(n!: String = "", v!: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()){
        this.n = n
        this.v = v
    }

    public func toString(): String {
        return "ContentModelD: { \n" +
               "n = ${n},\n" +
               "v = ${v} \n}"
    }
}
