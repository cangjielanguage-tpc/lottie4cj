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

    public let mn: String                         //8 = mn

    let _ty: String = "gf"
    public open prop ty: String {
        get() { _ty }
    }

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

    public func clone(): GradientFill {
        var tmpc = Array<Keyframe<Array<Float64>>>(this.c.size,{i => unsafe {zeroValue<Keyframe<Array<Float64>>>()}})
        for (i in 0..this.c.size) {
            tmpc[i] = this.c[i].clone()
        }
        var tmpw = Array<Keyframe<Float64>>(this.w.size,{i => unsafe {zeroValue<Keyframe<Float64>>()}})
        for (i in 0..this.w.size) {
            tmpw[i] = this.w[i].clone()
        }
        var tmpo = Array<Keyframe<Int64>>(this.o.size,{i => unsafe {zeroValue<Keyframe<Int64>>()}})
        for (i in 0..this.o.size) {
            tmpo[i] = this.o[i].clone()
        }
        var tmpd = Array<ContentModelD>(this.d.size,{i => unsafe {zeroValue<ContentModelD>()}})
        for (i in 0..this.d.size) {
            tmpd[i] = this.d[i].clone()
        }
        var tmps = Array<Keyframe<Array<Float64>>>(this.s.size,{i => unsafe {zeroValue<Keyframe<Array<Float64>>>()}})
        for (i in 0..this.s.size) {
            tmps[i] = this.s[i].clone()
        }
        var tmpe = Array<Keyframe<Array<Float64>>>(this.e.size,{i => unsafe {zeroValue<Keyframe<Array<Float64>>>()}})
        for (i in 0..this.e.size) {
            tmpe[i] = this.e[i].clone()
        }
        var sc = GradientFill(
            nm: this.nm,
            g: this.g.clone(),
            o: tmpo,
            t: this.t,
            s: tmps,
            e: tmpe,
            r: this.r,
            hd: this.hd,
            mn: this.mn,
            a: this.a.clone()
        )
        sc.c = tmpc
        sc.w = tmpw
        sc.d = tmpd
        sc.lc = this.lc
        sc.lj = this.lj
        sc.ml = this.ml
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
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
