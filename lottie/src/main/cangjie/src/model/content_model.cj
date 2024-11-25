/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ContentModel structure.
 */
package lottie.model

public open class ContentModel <: ToString {

    public var hd: Bool = false

    public var _processed: Bool = false
    public var _render: Bool = false
    public var _shouldRender: Bool = false

    public open func clone(): ContentModel {
        var sc = ContentModel()
        sc.hd = this.hd
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
    }

    public open prop ty: String {
        get() { "ContentModel" }
    }

    /**
     * Obtain the type of ContentModel.
     */
    public open prop types: Int8 {
        get() { -1 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public open func toString(): String { "The ContentModel is None." }
}

public open class ContentModelP <: ToString {

    public let p: Int64
    public let k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ContentModelP instance based on parameters.
     *
     * @param p - Type of Int64, the value of p.
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(p!: Int64 = 0, k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this.p = p
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelP: {\n" +
               "p = ${p},\n" +
               "k = ${k}\n}"
    }
    public func clone(): ContentModelP {
        var tmpk = Array<Keyframe<Array<Float64>>>(this.k.size,{i => unsafe {zeroValue<Keyframe<Array<Float64>>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var sc = ContentModelP(p: this.p, k: tmpk)
        return sc
    }
}

public open class ContentModelPK <: ToString {

    public let k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ContentModelPK instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelPK: { k = ${k} }"
    }
}

public open class ContentModelD <: ToString {

    public let n: String
    public let v: ContentModelDK

    /**
     * Create a ContentModelD instance based on parameters.
     *
     * @param n - Type of String, the value of n.
     * @param v - Type of ContentModelDK, the value of v.
     */
    public init(n!: String = "", v!: ContentModelDK = ContentModelDK()){
        this.n = n
        this.v = v
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelD: {\n" +
               "n = ${n},\n" +
               "v = ${v}\n}"
    }

    public func clone(): ContentModelD {
        return ContentModelD(n: this.n,v: this.v.clone())
    }
}

public open class ContentModelDK <: ToString {
    public let k: Array<Keyframe<Float64>>

    /**
     * Create a ContentModelDK instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<Float64>>, the value of k.
     */
    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()){
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelDK: { k = ${k} }"
    }

    public func clone(): ContentModelDK {
        var tmpk = Array<Keyframe<Float64>>(this.k.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        return ContentModelDK(k:tmpk)
    }
}
