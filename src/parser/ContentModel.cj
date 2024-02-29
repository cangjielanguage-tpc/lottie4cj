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

public open class ContentModelPK <: ToString {

    var k: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

    init(){}
    init(k: ArrayList<Keyframe<Array<Float64>>>){
        this.k = k
    }

    public func toString(): String {
        return "ContentModelPK: { k = ${k} }"
    }
}

public open class ContentModelD <: ToString {

    var n: String = ""
    var v: ContentModelDK = ContentModelDK()

    init(n!: String = "", v!: ContentModelDK = ContentModelDK()){
        this.n = n
        this.v = v
    }

    public func toString(): String {
        return "ContentModelD: { \n" +
               "n = ${n},\n" +
               "v = ${v} \n}"
    }
}

public open class ContentModelDK <: ToString {
    var k: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

    init(){}
    init(k: ArrayList<Keyframe<Float64>>){
        this.k = k
    }

    public func toString(): String {
        return "ContentModelDK: { k = ${k} }"
    }
}
