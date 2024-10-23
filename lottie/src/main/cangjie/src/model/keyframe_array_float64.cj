/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeFill structure.
 */
package lottie.model

/**
 * 1. "layers"."shapes".{"ty": "st"} = ShapeStrokeParser
 * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
 */
public class KeyframeArrayFloat64 <: ToString {

    /**
     * 若 layers[i].shapes[j].c.k 是一个数组值，结果保存在 k 中；
     * 若 layers[i].shapes[j].c.k 是一个数组对象，其中的一个对象结果保存在 k 之外的其他成员变量中；
     */
    public var k: Array<Float64>
    //若为 true，则 k 中无数据；若为 false，则 k 中有数据。
    public var kIsArray: Bool = false

    public var t: Float64            // 0

    public var s: Array<Float64>     // 1
    public var e: Array<Float64>     // 2

    public var o: PointF             // 3
    public var i: PointF             // 4
    public var h: Int64              // 5

    public var to: Array<Float64>    // 6
    public var ti: Array<Float64>    // 7

    /**
     * Create a Keyframe instance based on parameters.
     *
     * @param k - Type of Array<Float64>, the value of k.
     * @param t - Type of Float64, the value of t.
     * @param s - Type of Array<Float64>, the value of s.
     * @param e - Type of Array<Float64>, the value of e.
     * @param o - Type of PointF, the value of o.
     * @param i - Type of PointF, the value of i.
     * @param h - Type of Int64, the value of h.
     * @param to - Type of Array<Float64>, the value of to.
     * @param ti - Type of Array<Float64>, the value of ti.
     */
    public init(
        k!: Array<Float64> = Array<Float64>(),
        t!: Float64 = 0.0,
        s!: Array<Float64> = Array<Float64>(),
        e!: Array<Float64> = Array<Float64>(),
        o!: PointF = PointF(),
        i!: PointF = PointF(),
        h!: Int64 = 0,
        to!: Array<Float64> = Array<Float64>(),
        ti!: Array<Float64> = Array<Float64>()
    ){
        this.k = k
        this.t = t
        this.s = s
        this.e = e
        this.o = o
        this.i = i
        this.h = h
        this.to = to
        this.ti = ti
    }
    
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "KeyframeArrayFloat64{\n" +
               "kIsArray = ${kIsArray}\n" +
               "k = ${k}\n" +
               "t = ${t}\n" +
               "s = ${s}\n" +
               "e = ${e}\n" +
               "o = ${o}\n" +
               "i = ${i}\n" +
               "h = ${h}\n" +
               "to = ${to}\n" +
               "ti = ${ti}\n}"
    }
}
