/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeStroke structure.
 */
package lottie.model

public class ShapeStroke <: FillStroke {

    //新增成员变量，解析部分待补充。
    public let mn: String = ""

    //将 ShapeStroke._c 的值再次加工处理，保存在 c_k 中
    public var c_k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

    /**
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStrokeParser
     */
    public let nm: String                              // 0 = name

    let _ty: String = "st"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a ShapeStroke instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param c - Type of Array<Keyframe<Array<Float64>>>, the value of c.
     * @param w - Type of Array<Keyframe<Float64>>, the value of w.
     * @param o - Type of Array<Keyframe<Int64>>, the value of o.
     * @param lc - Type of Int64, the value of lc.
     * @param lj - Type of Int64, the value of lj.
     * @param ml - Type of Float64, the value of ml.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Array<ContentModelD>, the value of d.
     */
    public init(
        nm!: String = "",
        c!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        w!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        lc!: Int64 = 0,
        lj!: Int64 = 0,
        ml!: Float64 = 0.0,
        hd!: Bool = false,
        d!: Array<ContentModelD> = Array<ContentModelD>()
    ){
        this.nm = nm
        this.c = c
        this.c_k = c
        this.w = w
        this.o = o
        this.lc = lc
        this.lj = lj
        this.ml = ml
        this.hd = hd
        this.d = d
    }

    /**
     * Obtain the type of ShapeStroke.
     */
    public override prop types: Int8 {
        get() { 1 }
    }

    public func clone(): ShapeStroke {
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
        var sc = ShapeStroke(
            nm: this.nm,
            c: tmpc,
            w: tmpw,
            o: tmpo,
            lc: this.lc,
            lj: this.lj,
            ml: this.ml,
            hd: this.hd,
            d: tmpd
        )
        sc.c_k = tmpc
        sc.s = tmps
        sc.e = tmpe
        sc.r = r
        sc.t = t
        sc.a = this.a.clone()
        sc.g = this.g.clone()
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeStroke[st]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${c}\n" +
               "w = ${w}\n" +
               "o = ${o}\n" +
               "lc = ${lc}\n" +
               "lj = ${lj}\n" +
               "ml = ${ml}\n" +
               "hd = ${hd}\n" +
               "d = ${d}\n}"
    }

}
