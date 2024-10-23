/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ContentModel structure.
 */
package lottie.model

public open class ContentModel <: ToString {

    //TODO: 在 CVShapeElement.createStyleElement 编译用。
    public var hd: Bool = false

     //TODO：编译调试用，后续要再确认。
    public var _processed: Bool = false
    public var _render: Bool = false
    public var _shouldRender: Bool = false
    //TODO: 逐级实现 clone() 函数.
    public open func clone(): ContentModel {
        return this
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
    private let _k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ContentModelP instance based on parameters.
     *
     * @param p - Type of Int64, the value of p.
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(p!: Int64 = 0, k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this.p = p
        this._k = k
    }

    /**
     * Obtain the k of ContentModelP.
     */
    public prop k: Array<Keyframe<Array<Float64>>> {
        get() { this._k.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelP: {\n" +
               "p = ${p},\n" +
               "k = ${_k}\n}"
    }
}

public open class ContentModelPK <: ToString {

    private let _k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ContentModelPK instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this._k = k
    }

    /**
     * Obtain the k of ContentModelPK.
     */
    public prop k: Array<Keyframe<Array<Float64>>> {
        get() { this._k.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelPK: { k = ${_k} }"
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
}

public open class ContentModelDK <: ToString {
    private let _k: Array<Keyframe<Float64>>

    /**
     * Create a ContentModelDK instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<Float64>>, the value of k.
     */
    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()){
        this._k = k
    }

    /**
     * Obtain the k of ContentModelDK.
     */
    public prop k: Array<Keyframe<Float64>> {
        get() { this._k.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ContentModelDK: { k = ${_k} }"
    }
}
