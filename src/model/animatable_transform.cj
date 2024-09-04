/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTransform structure.
 */
package lottie4cj.model

public class AnimatableTransform <: ContentModel {

    public var nm: String = "Transform"
    
    /**
     * 5. "layers"."shapes".{"ty": "tr"} = AnimatableTransformParser
     */
    public let a: ArrayKeyframePointF                    // 0 = anchorPoint
    public let p: AnimatableSplitDimensionPathValue      // 1 = position       // k: ArrayKeyframePointF
    public let s: ArrayKeyframeArrayFloat64              // 2 = scale
    public let r: ArrayKeyframeFloat64                   // 4 = rotation
    public let o: ArrayKeyframeInt64                     // 5 = opacity
    //"so": {"a": 0, "k": 100, "ix": 5}
    public let so: ArrayKeyframeFloat64                  // 6 = startOpacity
    //"eo": {"a": 0, "k": 100, "ix": 6}
    public let eo: ArrayKeyframeFloat64                  // 7 = endOpacity
    public let sk: ArrayKeyframeFloat64                  // 8 = skew
    public let sa: ArrayKeyframeFloat64                  // 9 = skewAngle

    public let _ty: String
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a AnimatableTransform instance based on parameters.
     *
     * @param a - Type of ArrayKeyframePointF, the value of a.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of ArrayKeyframeArrayFloat64, the value of s.
     * @param r - Type of ArrayKeyframeFloat64, the value of r.
     * @param o - Type of ArrayKeyframeInt64, the value of o.
     * @param so - Type of ArrayKeyframeFloat64, the value of so.
     * @param eo - Type of ArrayKeyframeFloat64, the value of eo.
     * @param sk - Type of ArrayKeyframeFloat64, the value of sk.
     * @param sa - Type of ArrayKeyframeFloat64, the value of sa.
     * @param ty - Type of String, the value of ty.
     * @param nm - Type of String, the value of nm.
     */
    public init(
        a!: ArrayKeyframePointF = ArrayKeyframePointF(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64(),
        r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        o!: ArrayKeyframeInt64 = ArrayKeyframeInt64(),
        so!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        eo!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        sk!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        sa!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        ty!: String = "",
        nm!: String = "Transform"
    ){
        this.a = a
        this.p = p
        this.s = s
        this.r = r
        this.o = o
        this.so = so
        this.eo = eo
        this.sk = sk
        this.sa = sa
        this._ty = ty
        this.nm = nm
    }

    /**
     * Obtain the type of AnimatableTransform.
     */
    public override prop types: Int8 {
        get() { 5 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableTransform[tr]: {\n" +
               "ty = ${_ty},\n" +
               "a = ${a.k},\n" +
               "p = ${p},\n" +
               "s = ${s.k},\n" +
               "r = ${r},\n" +
               "o = ${o.k},\n" +
               "so = ${so.k},\n" +
               "eo = ${eo.k},\n" +
               "sk = ${sk.k},\n" +
               "sa = ${sa.k}\n}"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return a.k.size == 0 &&
                p.isNull() &&
                s.k.size == 0 &&
                r.isNull() &&
                o.k.size == 0 &&
                so.k.size == 0 &&
                eo.k.size == 0 &&
                sk.k.size == 0 &&
                sa.k.size == 0 &&
                _ty == ""
    }
}
