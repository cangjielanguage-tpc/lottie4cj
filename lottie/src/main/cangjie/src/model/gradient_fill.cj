/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a GradientFill structure.
 */
package lottie.model

public class GradientFill <: FillStroke {

    /**
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFillParser
     */
    public let nm: String                        //0 = name

    // "g": {"p": points/Int64, "k": color/Array<Keyframe<T>>}  => Array<Keyframe<Array<Float64>>>
    //public let g: ContentModelP                  //1 = {points, color}

    //public let o: Array<Keyframe<Int64>>       //2 = opacity
    //public let t: Int64                          //3 = gradientType

    ////private let _s: Array<Keyframe<PointF>>      //4 = startPoint
    ////private let _e: Array<Keyframe<PointF>>      //5 = endPoint
    //public let s: Array<Keyframe<Array<Float64>>>      //4 = startPoint
    //public let e: Array<Keyframe<Array<Float64>>>      //5 = endPoint

    //public let r: Int64                          //6 = fillTypeInt
    //public let hd: Bool                          //7 = hidden

    public let mn: String                         //8 = mn
    //public let a: AK                              //9 = mn

    let _ty: String = "gf"
    public open prop ty: String {
        get() { _ty }
    }

    //public let s_k: Array<Int64>      //4 = startPoint
    //public let e_k: Array<Int64>      //5 = endPoint

    /**
     * Create a GradientFill instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param g - Type of ContentModelP, the value of g.
     * @param o - Type of Array<Keyframe<Int64>>, the value of o.
     * @param t - Type of Int64, the value of t.
     * @param s - Type of Array<Keyframe<PointF>>, the value of s.
     * @param e - Type of Array<Keyframe<PointF>>, the value of e.
     * @param r - Type of Int64, the value of r.
     * @param hd - Type of Bool, the value of hd.
     * @param mn - Type of String, the value of mn.
     * @param a - Type of AK, the value of a.
     */
    public init(
        nm!: String = "",
        g!: ContentModelP = ContentModelP(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        t!: Int64 = 0,
        //s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        //e!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        s!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        e!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        r!: Int64 = 0,
        hd!: Bool = false,
        mn!: String = "",
        a!: AK = AK()
    ){
        this.nm = nm
        this.g = g
        this.o = o
        this.t = t
        this.s = s
        this.e = e
        this.r = r
        this.hd = hd
        this.mn = mn
        this.a = a
    }

    /**
     * Obtain the type of GradientFill.
     */
    public override prop types: Int8 {
        get() { 4 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "GradientFill[gf]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "g = ${g}\n" +
               "o = ${o}\n" +
               "t = ${t}\n" +
               "s = ${s}\n" +
               "e = ${e}\n" +
               "r = ${r}\n" +
               "hd = ${hd}\n}"
    }
}
