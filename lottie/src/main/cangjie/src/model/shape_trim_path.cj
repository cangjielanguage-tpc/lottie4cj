/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeTrimPath structure.
 */
package lottie.model

public class ShapeTrimPath <: ContentModel {

    //新增成员变量，解析部分待补充。
    public var ix: Int64 = 0
    public let mn: String = ""

    /**
     * 9. "layers"."shapes".{"ty": "tm"} = ShapeTrimPathParser
     */
    //"s": {"a": 0, "k": 0, "ix": 1}
    public let s: ArrayKeyframeFloat64          // 0 = start
    //"e":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":37,"s":[0],"e":[100]},{"t":58.0000023623884}],"ix":2}
    public let e: ArrayKeyframeFloat64          // 1 = end
    //"o":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":37,"s":[18],"e":[0]},{"t":58.0000023623884}],"ix":3}
    public let o: ArrayKeyframeFloat64          // 2 = offset
    public let nm: String                       // 3 = name
    public let m: Int64                         // 4 = type

    let _ty: String = "tm"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a ShapeTrimPath instance based on parameters.
     *
     * @param s - Type of ArrayKeyframeFloat64, the value of s.
     * @param e - Type of ArrayKeyframeFloat64, the value of e.
     * @param o - Type of ArrayKeyframeFloat64, the value of o.
     * @param nm - Type of String, the value of nm.
     * @param m - Type of Int64, the value of m.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        s!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        e!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        o!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        nm!: String = "",
        m!: Int64 = 0,
        hd!: Bool = false
    ){
        this.s = s
        this.e = e
        this.o = o
        this.nm = nm
        this.m = m
        this.hd = hd
    }

    /**
     * Obtain the type of ShapeTrimPath.
     */
    public override prop types: Int8 {
        get() { 9 }
    }

    public func clone(): ShapeTrimPath {
        var sc = ShapeTrimPath(s: this.s.clone(), e: this.e.clone(), o: this.o.clone(), nm: this.nm,m: this.m, hd: this.hd)
        sc.ix = this.ix
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
        return "ShapeTrimPath[tm]: {\n" +
               "ty = ${ty}\n" +
               "s = ${s.k}\n" +
               "e = ${e.k}\n" +
               "o = ${o.k}\n" +
               "nm = ${nm}\n" +
               "m = ${m}\n" +
               "hd = ${hd}\n}"
    }
}
