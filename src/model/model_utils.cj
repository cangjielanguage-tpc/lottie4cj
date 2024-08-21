/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ArrayKeyframeArrayFloat64 structure.
 */
package lottie4cj.model


public class ArrayKeyframeArrayFloat64 <: ToString {

    private let _k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ArrayKeyframeArrayFloat64 instance based on parameters.
     *
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this._k = k
    }

    /**
     * Obtain the k of ArrayKeyframeArrayFloat64.
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
        return "ArrayKeyframeArrayFloat64: { k = ${_k} }"
    }
}

public class ArrayKeyframeFloat64 <: ToString {
    
    public var a: Int64 = 0
    public var ix: Int64 = 0
    
    private let _k: Array<Keyframe<Float64>>

    /**
     * Create a ArrayKeyframeFloat64 instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<Float64>>, the value of k.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    ){
        this.a = a
        this.ix = ix
        this._k = k
    }

    /**
     * Obtain the k of ArrayKeyframeFloat64.
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
        return "ArrayKeyframeFloat64: { k = ${_k} }"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return _k.size == 0
    }
}
