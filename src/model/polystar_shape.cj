/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a PolystarShape structure.
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

    let _ty: String = "sr"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a PolystarShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param sy - Type of Int64, the value of sy.
     * @param pt - Type of Array<Keyframe<Float64>>, the value of pt.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param r - Type of Array<Keyframe<Float64>>, the value of r.
     * @param or - Type of Array<Keyframe<Float64>>, the value of or.
     * @param os - Type of Array<Keyframe<Float64>>, the value of os.
     * @param ir - Type of Array<Keyframe<Float64>>, the value of ir.
     * @param is2 - Type of Array<Keyframe<Float64>>, the value of is.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Int64, the value of d.
     */
    public init(
        nm!: String = "",
        sy!: Int64 = 0,
        pt!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        or!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        os!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        ir!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        is2!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        hd!: Bool = false,
        d!: Int64 = 0
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

    /**
     * Obtain the type of PolystarShape.
     */
    public override prop types: Int8 {
        get() { 10 }
    }

    /**
     * Obtain the pt of PolystarShape.
     */
    public prop pt: Array<Keyframe<Float64>> {
        get() { this._pt.clone() }
    }

    /**
     * Obtain the r of PolystarShape.
     */
    public prop r: Array<Keyframe<Float64>> {
        get() { this._r.clone() }
    }

    /**
     * Obtain the or of PolystarShape.
     */
    public prop or: Array<Keyframe<Float64>> {
        get() { this._or.clone() }
    }

    /**
     * Obtain the os of PolystarShape.
     */
    public prop os: Array<Keyframe<Float64>> {
        get() { this._os.clone() }
    }

    /**
     * Obtain the ir of PolystarShape.
     */
    public prop ir: Array<Keyframe<Float64>> {
        get() { this._ir.clone() }
    }

    /**
     * Obtain the is of PolystarShape.
     */
    public prop is2: Array<Keyframe<Float64>> {
        get() { this._is.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
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
               "is2 = ${_is}\n" +
               "hd = ${hd}\n" +
               "d = ${d}\n}"
    }
}
