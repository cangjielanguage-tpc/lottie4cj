/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Repeater structure.
 */
package lottie.model

public class Repeater <: ContentModel {
    //新增成员变量，解析部分待补充。
    public let mn: String = ""

    public var ix: Int64 = -1
    public var m: Int64 = -1

    /**
     * 12. "layers"."shapes".{"ty": "rp"} = RepeaterParser
     */
    public let nm: String                          // 0 = name
    //"c": {"a": 0, "k": 2, "ix": 1}
    public let c: ArrayKeyframeFloat64             // 1 = copies
    //"o": {"a": 0, "k": 0, "ix": 2}
    public let o: ArrayKeyframeFloat64             // 2 = offset
    public let tr: AnimatableTransform             // 3 = transform

    let _ty: String = "rp"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a Repeater instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param c - Type of ArrayKeyframeFloat64, the value of c.
     * @param o - Type of ArrayKeyframeFloat64, the value of o.
     * @param tr - Type of AnimatableTransform, the value of tr.
     * @param hd - Type of Bool, the value of hd.
     * @param ix - Type of Int64, the value of ix.
     * @param m - Type of Int64, the value of m.
     */
    public init(
        nm!: String = "",
        c!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        o!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        tr!: AnimatableTransform = AnimatableTransform(),
        hd!: Bool = false,
        ix!: Int64 = -1,
        m!: Int64 = -1
    ){
        this.nm = nm
        this.c = c
        this.o = o
        this.tr = tr
        this.hd = hd
        this.ix = ix
        this.m = m
    }

    /**
     * Obtain the type of Repeater.
     */
    public override prop types: Int8 {
        get() { 12 }
    }

    public func clone(): Repeater {
        var sc = Repeater(nm: this.nm,c: this.c.clone(), o: this.o.clone(),tr: this.tr.clone(), hd: this.hd,ix: this.ix, m: this.m)
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
        return "Repeater[rp]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${c.k}\n" +
               "o = ${o.k}\n" +
               "tr = ${tr}\n" +
               "hd = ${hd}\n}"
    }
}
