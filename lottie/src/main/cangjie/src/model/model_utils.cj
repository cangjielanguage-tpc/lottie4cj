/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ArrayKeyframeArrayFloat64 structure.
 */
package lottie.model


public class ArrayKeyframeArrayFloat64 <: ToString {
    
    public var a: Int64 = 0
    public var ix: Int64 = 0
    
    public var k: Array<Keyframe<Array<Float64>>>

    /**
     * Create a ArrayKeyframeFloat64 instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<Array<Float64>>>, the value of k.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()){
        this.a = a
        this.ix = ix
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ArrayKeyframeArrayFloat64: { k = ${k} }"
    }

    public func clone(): ArrayKeyframeArrayFloat64 {
        var tmpk = Array<Keyframe<Array<Float64>>>(this.k.size,{i => unsafe {zeroValue<Keyframe<Array<Float64>>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var sc = ArrayKeyframeArrayFloat64(a: this.a, ix: this.ix, k: tmpk)
        return sc
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return k.size == 0
    }
}


public class ArrayKeyframeFloat64 <: ToString {
    
    public var a: Int64 = 0
    public var ix: Int64 = 0
    
    public var k: Array<Keyframe<Float64>>

    /**
     * Create a ArrayKeyframeFloat64 instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<Float64>>, the value of k.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()){
        this.a = a
        this.ix = ix
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ArrayKeyframeFloat64: { k = ${k} }"
    }

    public func clone(): ArrayKeyframeFloat64 {
        var tmpk = Array<Keyframe<Float64>>(this.k.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var sc = ArrayKeyframeFloat64(a: this.a, ix: this.ix, k: tmpk)
        return sc
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return k.size == 0
    }
}

public class ArrayKeyframeInt64 <: ToString {
    
    public var a: Int64 = 0
    public var ix: Int64 = 0
    
    public var k: Array<Keyframe<Int64>>

    /**
     * Create a ArrayKeyframeFloat64 instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<Int64>>, the value of k.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, k!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()){
        this.a = a
        this.ix = ix
        this.k = k
    }

    public func clone(): ArrayKeyframeInt64 {
        var tmpk = Array<Keyframe<Int64>>(this.k.size,{i => unsafe {zeroValue<Keyframe<Int64>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var sc = ArrayKeyframeInt64(a: this.a, ix: this.ix, k: tmpk)
        return sc
    }
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ArrayKeyframeInt64: { k = ${k} }"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return k.size == 0
    }
}

public class ArrayKeyframePointF <: ToString {
    
    public var a: Int64 = 0
    public var ix: Int64 = 0
    
    public var k: Array<Keyframe<PointF>>

    /**
     * Create a ArrayKeyframeFloat64 instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param ix - Type of Int64, the value of ix.
     * @param k - Type of Array<Keyframe<PointF>>, the value of k.
     */
    public init(a!: Int64 = 0, ix!: Int64 = 0, k!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()){
        this.a = a
        this.ix = ix
        this.k = k
    }


    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ArrayKeyframePointF: { k = ${k} }"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return k.size == 0
    }

    public func clone(): ArrayKeyframePointF {
        var tmpk = Array<Keyframe<PointF>>(this.k.size,{i => unsafe {zeroValue<Keyframe<PointF>>()}})
        for (i in 0..this.k.size) {
            tmpk[i] = this.k[i].clone()
        }
        var sc = ArrayKeyframePointF(a: this.a, ix: this.ix, k: tmpk)
        return sc
    }
}
