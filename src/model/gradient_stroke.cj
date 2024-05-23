/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GradientStroke structure.
 */
package model

public class GradientStroke <: ContentModel {

    /**
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStrokeParser
     */
    public let nm: String                       //0 = name

    // "g": {"p": points/Int64, "k": color/Array<Keyframe<T>>} => Array<Keyframe<Array<Float64>>>
    public let g: ContentModelP                 //1 = {points, color}

    private let _o: Array<Keyframe<Int64>>      //2 = opacity
    public let t: Int64                         //3 = gradientType
    private let _s: Array<Keyframe<PointF>>     //4 = startPoint
    private let _e: Array<Keyframe<PointF>>     //5 = endPoint
    private let _w: Array<Keyframe<Float64>>    //6 = width
    public let lc: Int64                        //7 = capType
    public let lj: Int64                        //8 = joinType
    public let ml: Float64                      //9 = miterLimit
    public let hd: Bool                         //10 = hidden

    //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  =>  Array<ContentModelD>
    private let _d: Array<ContentModelD>        //11 = lineDashPattern

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
     * @param s  - Type of Array<Keyframe<PointF>>, the value of s.
     * @param e  - Type of Array<Keyframe<PointF>>, the value of e.
     * @param w  - Type of Array<Keyframe<Float64>>, the value of w.
     * @param lc - Type of Int64, the value of lc.
     * @param lj - Type of Int64, the value of lj.
     * @param ml - Type of Float64, the value of ml.
     * @param hd - Type of Bool, the value of hd.
     * @param d  - Type of Array<ContentModelD>, the value of d.
     */
    public init(
        nm!: String = "",
        g!: ContentModelP = ContentModelP(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        t!: Int64 = 0,
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        e!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        w!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        lc!: Int64 = 0,
        lj!: Int64 = 0,
        ml!: Float64 = 0.0,
        hd!: Bool = false,
        d!: Array<ContentModelD> = Array<ContentModelD>()
    ){
        this.nm = nm
        this.g = g
        this._o = o
        this.t = t
        this._s = s
        this._e = e
        this._w = w
        this.lc = lc
        this.lj = lj
        this.ml = ml
        this.hd = hd
        this._d = d
    }

    /**
     * Obtain the type of GradientStroke.
     */
    public override prop types: Int8 {
        get() { 2 }
    }

    /**
     * Obtain the o of GradientStroke.
     */
    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    /**
     * Obtain the s of GradientStroke.
     */
    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    /**
     * Obtain the e of GradientStroke.
     */
    public prop e: Array<Keyframe<PointF>> {
        get() { this._e.clone() }
    }

    /**
     * Obtain the w of GradientStroke.
     */
    public prop w: Array<Keyframe<Float64>> {
        get() { this._w.clone() }
    }

    /**
     * Obtain the d of GradientStroke.
     */
    public prop d: Array<ContentModelD> {
        get() { this._d.clone() }
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
                "o = ${_o}\n" +
                "t = ${t}\n" +
                "s = ${_s}\n" +
                "e = ${_e}\n" +
                "w = ${_w}\n" +
                "lc = ${lc}\n" +
                "lj = ${lj}\n" +
                "ml = ${ml}\n" +
                "hd = ${hd}\n" +
                "d = ${_d}\n}"
    }

}
