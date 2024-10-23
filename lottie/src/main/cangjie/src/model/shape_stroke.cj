/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeStroke structure.
 */
package lottie.model

public class ShapeStroke <: FillStroke {

    //TODO:新增成员变量，解析部分暂未补上。
    public let mn: String = ""

    //将 ShapeStroke._c 的值再次加工处理，保存在 c_k 中
    //TODO: 将原来的 ShapeStroke.c，储存到 c_k 中；将再次加工处理的数据，储存到 ShapeStroke.c
    //public var c_k: Array<KeyframeArrayFloat64> = Array<KeyframeArrayFloat64>()    // 1 = color
    public var c_k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

    /**
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStrokeParser
     */
    public let nm: String                              // 0 = name
    //public let c: Array<Keyframe<Array<Float64>>>    // 1 = color
    //public let w: Array<Keyframe<Float64>>           // 2 = width
    //public let o: Array<Keyframe<Int64>>             // 3 = opacity
    //public let lc: Int64                               // 4 = capType
    //public let lj: Int64                               // 5 = joinType
    //public let ml: Float64                             // 6 = miterLimit
    //public let hd: Bool                                // 7 = hidden
    //public let d: Array<ContentModelD>               // 8 = lineDashPattern
    //"d": [{"n": "String "v": Array<Keyframe<T>>}]

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

    /**
     * Obtain the c of ShapeStroke.
     */
    //public prop c: Array<Keyframe<Array<Float64>>> {
    //    get() { this._c.clone() }
    //}

    /**
     * Obtain the w of ShapeStroke.
     */
    //public prop w: Array<Keyframe<Float64>> {
    //    get() { this._w.clone() }
    //}

    /**
     * Obtain the o of ShapeStroke.
     */
    //public prop o: Array<Keyframe<Int64>> {
    //    get() { this._o.clone() }
    //}

    /**
     * Obtain the d of ShapeStroke.
     */
    //public prop d: Array<ContentModelD> {
    //    get() { this._d.clone() }
    //}

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
