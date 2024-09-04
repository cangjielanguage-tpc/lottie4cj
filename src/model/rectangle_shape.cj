/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a RectangleShape structure.
 */
package lottie4cj.model

public class RectangleShape <: ContentModel {

    /**
     * 8. "layers"."shapes".{"ty": "rc"} = RectangleShapeParser
     */
    public let nm: String                                // 0 = name
    //TODO: 是否要改成 Array<Keyframe<Array<Float64>>>？？？
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    //TODO: 是否要改成 Array<Keyframe<Array<Float64>>>？？？
    public let s: ArrayKeyframePointF                    // 2 = size
    public let r: ArrayKeyframeFloat64                   // 3 = roundedness
    public let hd: Bool                                  // 4 = hidden
    
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
