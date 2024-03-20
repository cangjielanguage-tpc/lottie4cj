/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a RoundedCorners structure.
 */
package model

public class RoundedCorners <: ContentModel {

    /**
     * 13. "layers"."shapes".{"ty": "rd"} = RoundedCornersParser
     */
    public let nm: String                          // 0
    private let _r: Array<Keyframe<Float64>>       // 1
    public let hd: Bool                            // 2

    let ty: String = "rd"

    /**
     * Create a RoundedCorners instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param r - Type of Array<Keyframe<Float64>>, the value of r.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(nm!: String = "", r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(), hd!: Bool = false){
        this.nm = nm
        this._r = r
        this.hd = hd
    }

    /**
     * Obtain the type of RoundedCorners.
     */
    public override prop types: Int8 {
        get() { 13 }
    }

    /**
     * Obtain the r of RoundedCorners.
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
        return "RoundedCorners[rd]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "r = ${_r}\n" +
               "hd = ${hd}\n}"
    }
}
