/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimatableSplitDimensionPathValue structure.
 */
package lottie.model

public class AnimatableSplitDimensionPathValue <: ToString {
    
    public var a: Int64
    public var ix: Int64

    public let k: Array<Keyframe<PointF>>
    public let x: Array<Keyframe<Float64>>
    public let y: Array<Keyframe<Float64>>

    //暂未在 json 中找到 z。暂定为 Array<Keyframe<Float64>>。TransformProperty中编译用。
    public var z: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    public var s: Bool

    /**
     * Create a AnimatableSplitDimensionPathValue instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<PointF>>, the value of k.
     * @param x - Type of Array<Keyframe<Float64>>, the value of x.
     * @param y - Type of Array<Keyframe<Float64>>, the value of y.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, s!: Bool = false,
        k!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        x!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        y!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    ) {
        this.a = a
        this.ix = ix
        this.s = s
        this.k = k
        this.x = x
        this.y = y
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableSplitDimensionPathValue: {\n" +
               "k = ${k}\n" +
               "x = ${x}\n" +
               "y = ${y}\n}"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return k.size == 0 && x.size == 0 && y.size == 0
    }

    public func clone(): AnimatableSplitDimensionPathValue {
        var tmpk = Array<Keyframe<PointF>>(this.k.size,{i => unsafe {zeroValue<Keyframe<PointF>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var tmpx = Array<Keyframe<Float64>>(this.x.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.x.size) {
            tmpx[i] = this.x[i].clone()
        }
        var tmpy = Array<Keyframe<Float64>>(this.y.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.y.size) {
            tmpy[i] = this.y[i].clone()
        }
        var tmpz= Array<Keyframe<Float64>>(this.z.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.z.size) {
            tmpz[i] = this.z[i].clone()
        }
        var sc = AnimatableSplitDimensionPathValue(a: this.a, ix: this.ix, s: this.s,k: tmpk, x: tmpx, y: tmpz)
        sc.z = tmpz
        return sc
    }
}
