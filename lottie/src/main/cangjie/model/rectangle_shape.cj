/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a RectangleShape structure.
 */
package lottie.model

public class RectangleShape <: ContentModel {

    //新增成员变量，解析部分待补充。
    public var ix: Int64 = 0

    public var mn: String = ""

    /**
     * 8. "layers"."shapes".{"ty": "rc"} = RectangleShapeParser
     */
    public let nm: String                                // 0 = name
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    public let s: ArrayKeyframePointF                    // 2 = size
    public let r: ArrayKeyframeFloat64                   // 3 = roundedness
    
    public let d: Int64

    let _ty: String = "rc"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a RectangleShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of ArrayKeyframePointF, the value of s.
     * @param r - Type of ArrayKeyframeFloat64, the value of r.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Int64, the value of d.
     */
    public init(
        nm!: String = "",
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: ArrayKeyframePointF = ArrayKeyframePointF(),
        r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        hd!: Bool = false,
        d!: Int64 = -1
    ){
        this.nm = nm
        this.p = p
        this.s = s
        this.r = r
        this.hd = hd
        this.d = d
    }

    /**
     * Obtain the type of RectangleShape.
     */
    public override prop types: Int8 {
        get() { 8 }
    }

    public func clone(): RectangleShape {
        var sc = RectangleShape(nm: this.nm,p: this.p.clone(), s: this.s.clone(),r: this.r.clone(), hd: this.hd,d: this.d)
        sc.ix = this.ix
        sc.mn = this.mn
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
        return "RectangleShape[rc]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "p = ${p}\n" +
               "s = ${s.k}\n" +
               "r = ${r.k}\n" +
               "hd = ${hd}\n}"
    }
}
