/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class AnimatableTransform <: ContentModel {

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

    public let ty: String

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
        ty!: String = ""
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
        this.ty = ty
    }

    public override prop types: Int8 {
        get() { 5 }
    }

    public prop a: Array<Keyframe<PointF>> {
        get() { this._a.clone() }
    }
    public prop s: Array<Keyframe<Array<Float64>>> {
        get() { this._s.clone() }
    }

    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    public prop so: Array<Keyframe<Float64>> {
        get() { this._so.clone() }
    }
    public prop eo: Array<Keyframe<Float64>> {
        get() { this._eo.clone() }
    }
    public prop sk: Array<Keyframe<Float64>> {
        get() { this._sk.clone() }
    }
    public prop sa: Array<Keyframe<Float64>> {
        get() { this._sa.clone() }
    }

    public func toString(): String {
        return "AnimatableTransform[tr]: {\n" +
               "ty = ${ty},\n" +
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
}
