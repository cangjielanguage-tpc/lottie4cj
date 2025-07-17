/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a FillStroke structure.
 */
package lottie.model

//兼容(arr[i].ty === 'fl'/'st'/'gf'/'gs') 
public open class FillStroke <: ContentModel {

    /**
     * 兼容以下 4 种类型：
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStroke
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStroke
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFill
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFill
     */

    public var g: ContentModelP = ContentModelP()                                          //1 = {points, color}  //ContentModelP
    //指向的是已经处理的 c，即 "fl"/"st" 的 c_k
    public var c: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()      //1 = color

    public var o: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()                        //2 = opacity
    public var s: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()      //4 = startPoint
    public var e: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()      //5 = endPoint
    public var w: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()                    //6 = width
    //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  =>  Array<ContentModelD>
    public var d: Array<ContentModelD> = Array<ContentModelD>()                            //11 = lineDashPattern  //Array<ContentModelD>
    // h 成员变量暂时是空的。
    public var a: AK = AK()                                                                //12 = mn

    public var lc: Int64 = -1                          //7 = capType
    public var lj: Int64 = -1                          //8 = joinType
    public var ml: Float64 = -1.0                      //9 = miterLimit
    public var r: Int64 = 0

    public var t: Int64 = 0

    public open func clone(): FillStroke {
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
        var sc = FillStroke()
        sc.g = this.g.clone()
        sc.c = tmpc
        sc.o = tmpo
        sc.s = tmps
        sc.e = tmpe
        sc.w = tmpw
        sc.d = tmpd
        sc.a = this.a.clone()
        sc.lc = this.lc
        sc.lj = this.lj
        sc.ml = this.ml
        sc.r = this.r
        sc.t = this.t
        sc.hd = this.hd
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
    }
}
