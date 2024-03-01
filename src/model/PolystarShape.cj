/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class PolystarShape <: ContentModel {

    /**
     * 10. "layers"."shapes".{"ty": "sr"} = PolystarShapeParser
     */
    public let nm: String                                 // 0  = name
    public let sy: Int64                                  // 1  = type
    private let _pt: Array<Keyframe<Float64>>             // 2  = points
    public let p: AnimatableSplitDimensionPathValue       // 3  = position
    private let _r: Array<Keyframe<Float64>>              // 4  = rotation
    private let _or: Array<Keyframe<Float64>>             // 5  = outerRadius
    private let _os: Array<Keyframe<Float64>>             // 6  = outerRoundedness
    private let _ir: Array<Keyframe<Float64>>             // 7  = innerRadius
    private let _is: Array<Keyframe<Float64>>             // 8  = innerRoundedness
    public let hd: Bool                                   // 9  = hidden
    public let d: Int64                                   // 10 = reversed

    let ty: String = "sr"

    public init(nm!: String, sy!: Int64, pt!: Array<Keyframe<Float64>>, p!: AnimatableSplitDimensionPathValue,
        r!: Array<Keyframe<Float64>>, or!: Array<Keyframe<Float64>>, os!: Array<Keyframe<Float64>>,
        ir!: Array<Keyframe<Float64>>, is2!: Array<Keyframe<Float64>>, hd!: Bool, d!: Int64
    ){
        this.nm = nm
        this.sy = sy
        this._pt = pt
        this.p = p
        this._r = r
        this._or = or
        this._os = os
        this._ir = ir
        this._is = is2
        this.hd = hd
        this.d = d
    }

    public override prop types: Int8 {
        get() { 10 }
    }

    public prop pt: Array<Keyframe<Float64>> {
        get() { this._pt.clone() }
    }

    public prop r: Array<Keyframe<Float64>> {
        get() { this._r.clone() }
    }

    public prop or: Array<Keyframe<Float64>> {
        get() { this._or.clone() }
    }

    public prop os: Array<Keyframe<Float64>> {
        get() { this._os.clone() }
    }

    public prop ir: Array<Keyframe<Float64>> {
        get() { this._ir.clone() }
    }

    public prop is2: Array<Keyframe<Float64>> {
        get() { this._is.clone() }
    }

    public func toString(): String {
        return "PolystarShape[sr]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "sy = ${sy}\n" +
               "pt = ${_pt}\n" +
               "p = ${p}\n" +
               "r = ${_r}\n" +
               "or = ${_or}\n" +
               "os = ${_os}\n" +
               "ir = ${_ir}\n" +
               "is = ${_is}\n" +
               "hd = ${hd}\n" +
               "d = ${d}\n}"
    }
}
