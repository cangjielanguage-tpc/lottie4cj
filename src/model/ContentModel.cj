/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public open class ContentModel <: ToString {

    public open prop types: Int8 {
        get() { -1 }
    }

    public open func toString(): String { "The ContentModel is None." }
}

public open class ContentModelP <: ToString {

    public let p: Int64
    private let _k: Array<Keyframe<Array<Float64>>>

    public init(p!: Int64 = 0, k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this.p = p
        this._k = k
    }

    public prop k: Array<Keyframe<Array<Float64>>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "ContentModelP: {\n" +
               "p = ${p},\n" +
               "k = ${_k}\n}"
    }
}

public open class ContentModelPK <: ToString {

    private let _k: Array<Keyframe<Array<Float64>>>

    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this._k = k
    }

    public prop k: Array<Keyframe<Array<Float64>>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "ContentModelPK: { k = ${_k} }"
    }
}

public open class ContentModelD <: ToString {

    public let n: String
    public let v: ContentModelDK

    public init(n!: String = "", v!: ContentModelDK = ContentModelDK()){
        this.n = n
        this.v = v
    }

    public func toString(): String {
        return "ContentModelD: {\n" +
               "n = ${n},\n" +
               "v = ${v}\n}"
    }
}

public open class ContentModelDK <: ToString {
    private let _k: Array<Keyframe<Float64>>

    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()){
        this._k = k
    }

    public prop k: Array<Keyframe<Float64>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "ContentModelDK: { k = ${_k} }"
    }
}
