/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model


public class ArrayKeyframeArrayFloat64 <: ToString {

    private let _k: Array<Keyframe<Array<Float64>>>

    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this._k = k
    }

    public prop k: Array<Keyframe<Array<Float64>>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "ArrayKeyframeArrayFloat64: { k = ${_k} }"
    }
}

public class ArrayKeyframeFloat64 <: ToString {
    private let _k: Array<Keyframe<Float64>>

    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()){
        this._k = k
    }

    public prop k: Array<Keyframe<Float64>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "ArrayKeyframeFloat64: { k = ${_k} }"
    }
}
