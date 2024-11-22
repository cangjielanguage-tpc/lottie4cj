/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a GradientStroke structure.
 */
package lottie.model

public class GradientStroke <: FillStroke {

    /**
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStrokeParser
     */
    public let nm: String                       //0 = name

    let _ty: String = "gs"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a GradientStroke instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param g  - Type of ContentModelP, the value of g.
     * @param o  - Type of Array<Keyframe<Int64>>, the value of o.
     * @param t  - Type of Int64, the value of t.
     * @param s  - Type of Array<Keyframe<Array<Float64>>>, the value of s.
     * @param e  - Type of Array<Keyframe<Array<Float64>>>, the value of e.
     * @param w  - Type of Array<Keyframe<Float64>>, the value of w.
     * @param lc - Type of Int64, the value of lc.
     * @param lj - Type of Int64, the value of lj.
     * @param ml - Type of Float64, the value of ml.
     * @param hd - Type of Bool, the value of hd.
     * @param d  - Type of Array<ContentModelD>, the value of d.
     * @param a - Type of AK, the value of a.
     */
    public init(
        nm!: String = "",
        g!: ContentModelP = ContentModelP(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        t!: Int64 = 0,
        s!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        e!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        w!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        lc!: Int64 = 0,
        lj!: Int64 = 0,
        ml!: Float64 = 0.0,
        hd!: Bool = false,
        d!: Array<ContentModelD> = Array<ContentModelD>(),
        a!: AK = AK()
    ){
        this.nm = nm
        this.g = g
        this.o = o
        this.t = t
        this.s = s
        this.e = e
        this.w = w
        this.lc = lc
        this.lj = lj
        this.ml = ml
        this.hd = hd
        this.d = d
        this.a = a
    }

    /**
     * Obtain the type of GradientStroke.
     */
    public override prop types: Int8 {
        get() { 2 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "GradientStroke[gs]: {\n" +
                "ty = ${ty}\n" +
                "nm = ${nm}\n" +
                "g = ${g}\n" +
                "o = ${o}\n" +
                "t = ${t}\n" +
                "s = ${s}\n" +
                "e = ${e}\n" +
                "w = ${w}\n" +
                "lc = ${lc}\n" +
                "lj = ${lj}\n" +
                "ml = ${ml}\n" +
                "hd = ${hd}\n" +
                "d = ${d}\n}"
    }

}
