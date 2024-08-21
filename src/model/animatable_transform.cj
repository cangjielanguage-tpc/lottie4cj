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
    private let _a: Array<Keyframe<PointF>>              // 0 = anchorPoint
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    private let _s: Array<Keyframe<Array<Float64>>>      // 2 = scale
    public let r: ArrayKeyframeFloat64                   // 4 = rotation
    private let _o: Array<Keyframe<Int64>>               // 5 = opacity
    private let _so: Array<Keyframe<Float64>>            // 6 = startOpacity
    private let _eo: Array<Keyframe<Float64>>            // 7 = endOpacity
    private let _sk: Array<Keyframe<Float64>>            // 8 = skew
    private let _sa: Array<Keyframe<Float64>>            // 9 = skewAngle

    private let _ty: String
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a AnimatableTransform instance based on parameters.
     *
     * @param a - Type of Array<Keyframe<PointF>>, the value of a.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of Array<Keyframe<Array<Float64>>>, the value of s.
     * @param r - Type of ArrayKeyframeFloat64, the value of r.
     * @param o - Type of Array<Keyframe<Int64>>, the value of o.
     * @param so - Type of Array<Keyframe<Float64>>, the value of so.
     * @param eo - Type of Array<Keyframe<Float64>>, the value of eo.
     * @param sk - Type of Array<Keyframe<Float64>>, the value of sk.
     * @param sa - Type of Array<Keyframe<Float64>>, the value of sa.
     * @param ty - Type of String, the value of ty.
     * @param nm - Type of String, the value of nm.
     */
    public init(
        a!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        so!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        eo!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        sk!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        sa!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        ty!: String = "",
        nm!: String = "Transform"
    ){
        this._a = a
        this.p = p
        this._s = s
        this.r = r
        this._o = o
        this._so = so
        this._eo = eo
        this._sk = sk
        this._sa = sa
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
     * Obtain the a of AnimatableTransform.
     */
    public prop a: Array<Keyframe<PointF>> {
        get() { this._a.clone() }
    }

    /**
     * Obtain the s of AnimatableTransform.
     */
    public prop s: Array<Keyframe<Array<Float64>>> {
        get() { this._s.clone() }
    }

    /**
     * Obtain the o of AnimatableTransform.
     */
    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    /**
     * Obtain the so of AnimatableTransform.
     */
    public prop so: Array<Keyframe<Float64>> {
        get() { this._so.clone() }
    }

    /**
     * Obtain the eo of AnimatableTransform.
     */
    public prop eo: Array<Keyframe<Float64>> {
        get() { this._eo.clone() }
    }

    /**
     * Obtain the sk of AnimatableTransform.
     */
    public prop sk: Array<Keyframe<Float64>> {
        get() { this._sk.clone() }
    }

    /**
     * Obtain the sa of AnimatableTransform.
     */
    public prop sa: Array<Keyframe<Float64>> {
        get() { this._sa.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableTransform[tr]: {\n" +
               "ty = ${_ty},\n" +
               "a = ${_a},\n" +
               "p = ${p},\n" +
               "s = ${_s},\n" +
               "r = ${r},\n" +
               "o = ${_o},\n" +
               "so = ${_so},\n" +
               "eo = ${_eo},\n" +
               "sk = ${_sk},\n" +
               "sa = ${_sa}\n}"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return _a.size == 0 &&
                p.isNull() &&
                _s.size == 0 &&
                r.isNull() &&
                _o.size == 0 &&
                _so.size == 0 &&
                _eo.size == 0 &&
                _sk.size == 0 &&
                _sa.size == 0 &&
                _ty == ""
    }
}
