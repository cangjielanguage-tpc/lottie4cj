/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
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

    public init(nm!: String, r!: Array<Keyframe<Float64>>, hd!: Bool){
        this.nm = nm
        this._r = r
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 13 }
    }

    public prop r: Array<Keyframe<Float64>> {
        get() { this._r.clone() }
    }

    public func toString(): String {
        return "RoundedCorners[rd]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "r = ${_r}\n" +
               "hd = ${hd}\n}"
    }
}
