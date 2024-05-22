/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a RectangleShape structure.
 */
package model

public class RectangleShape <: ContentModel {

    /**
     * 8. "layers"."shapes".{"ty": "rc"} = RectangleShapeParser
     */
    public let nm: String                                // 0 = name
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    private let _s: Array<Keyframe<PointF>>              // 2 = size
    private let _r: Array<Keyframe<Float64>>             // 3 = roundedness
    public let hd: Bool                                  // 4 = hidden

    let _ty: String = "rc"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a RectangleShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of Array<Keyframe<PointF>>, the value of s.
     * @param r - Type of Array<Keyframe<Float64>>, the value of r.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        nm!: String = "",
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        hd!: Bool = false
    ){
        this.nm = nm
        this.p = p
        this._s = s
        this._r = r
        this.hd = hd
    }

    /**
     * Obtain the type of RectangleShape.
     */
    public override prop types: Int8 {
        get() { 8 }
    }

    /**
     * Obtain the s of RectangleShape.
     */
    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    /**
     * Obtain the r of RectangleShape.
     */
    public prop r: Array<Keyframe<Float64>> {
        get() { this._r.clone() }
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
               "s = ${_s}\n" +
               "r = ${_r}\n" +
               "hd = ${hd}\n}"
    }
}
