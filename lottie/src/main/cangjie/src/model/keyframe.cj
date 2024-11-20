/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Keyframe structure.
 */
package lottie.model

public class Keyframe<T> <: ToString where T <: ToString {

    public var n: Array<String>
    public var keyframeMetadata: (Float64) -> Float64 = {n => return n}

    //"layers"."shapes"."c"."k" == parseColor
    public var k: Option<T>

    //"layers"."shapes"."c"."k"  <==  "layers"."shapes".{"ty": "st"}
    public var t: Float64       // 0

    //s/e => Color     // 1/2
    public var s: Option<T>     // 1
    public var e: Option<T>     // 2

    public let o: PointF        // 3
    public let i: PointF        // 4
    public let h: Int64         // 5
    //public let to: PointF       // 6
    //public let ti: PointF       // 7

    public let to: Array<Float64>       // 6
    public let ti: Array<Float64>       // 7
    
    // 是否执行过，判断 k 是不是 None 的动作
    var handleKIsNone: Bool = false
    var isNoneK: Bool = false

    /**
     * Create a Keyframe instance based on parameters.
     *
     * @param k - Type of Option<T>, the value of k.
     * @param t - Type of Float64, the value of t.
     * @param s - Type of Option<T>, the value of s.
     * @param e - Type of Option<T>, the value of e.
     * @param o - Type of PointF, the value of o.
     * @param i - Type of PointF, the value of i.
     * @param h - Type of Int64, the value of h.
     * @param to - Type of PointF, the value of to.
     * @param ti - Type of PointF, the value of ti.
     */
    public init(
        k!: Option<T> = Option<T>.None,
        t!: Float64 = 0.0,
        s!: Option<T> = Option<T>.None,
        e!: Option<T> = Option<T>.None,
        o!: PointF = PointF(),
        i!: PointF = PointF(),
        h!: Int64 = 0,
        //to!: PointF = PointF(),
        //ti!: PointF = PointF()
        to!: Array<Float64> = Array<Float64>(),
        ti!: Array<Float64> = Array<Float64>(),
        n!: Array<String> = Array<String>()
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
        this.n = n
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        let strk: String = match (k) {
            case Some(v) => v.toString()
            case None => "None"
        }
        let strs: String = match (s) {
            case Some(v) => v.toString()
            case None => "None"
        }
        let stre: String = match (e) {
            case Some(v) => v.toString()
            case None => "None"
        }

        return "Keyframe{\n" +
               "k = ${strk}\n" +
               "t = ${t}\n" +
               "s = ${strs}\n" +
               "e = ${stre}\n" +
               "o = ${o}\n" +
               "i = ${i}\n" +
               "h = ${h}\n" +
               "to = ${to}\n" +
               "n = ${n}\n" +
               "ti = ${ti}\n}"
    }

    /**
     * The k in the instance is empty.
     *
     * @return Type of Bool, if the k in the instance is empty, return true.
     */
    public func kIsNone(): Bool {
        if (this.handleKIsNone) {
            return this.isNoneK
        }
        this.handleKIsNone = true
        if (let Some(v) <- k) {  //"k"
            this.isNoneK = false
            return false
        }
        this.isNoneK = true
        return true
    }
}
