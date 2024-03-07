/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a CircleShape structure.
 */
package model

public class CircleShape <: ContentModel {

    /**
     * 7. "layers"."shapes".{"ty": "el"} = CircleShapeParser
     */
    public let nm: String                                // 0 = name
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    private let _s: Array<Keyframe<PointF>>              // 2 = size
    public let hd: Bool                                  // 3 = hidden
    public let d: Int64                                  // 4 = reversed
    
    let ty: String = "el"

    /**
     * Create a CircleShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of Array<Keyframe<PointF>>, the value of s.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Int64, the value of d.
     */
    public init(nm!: String, p!: AnimatableSplitDimensionPathValue, s!: Array<Keyframe<PointF>>, hd!: Bool, d!: Int64){
        this.nm = nm
        this.p = p
        this._s = s
        this.hd = hd
        this.d = d
    }

    /**
     * Obtain the type of CircleShape.
     */
    public override prop types: Int8 {
        get() { 7 }
    }

    /**
     * Obtain the s of CircleShape.
     */
    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "CircleShape[el]: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "p = ${p},\n" +
               "s = ${_s},\n" +
               "hd = ${hd},\n" +
               "d = ${d}\n}"
    }
}
