/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapeTrimPath <: ContentModel {

    /**
     * 9. "layers"."shapes".{"ty": "tm"} = ShapeTrimPathParser
     */
    private let _s: Array<Keyframe<Float64>>    // 0 = start
    private let _e: Array<Keyframe<Float64>>    // 1 = end
    private let _o: Array<Keyframe<Float64>>    // 2 = offset
    public let nm: String                       // 3 = name
    public let m: Int64                         // 4 = type
    public let hd: Bool                         // 5 = hidden

    let ty: String = "tm"

    public init(s!: Array<Keyframe<Float64>>, e!: Array<Keyframe<Float64>>, o!: Array<Keyframe<Float64>>,
        nm!: String, m!: Int64, hd!: Bool
    ){
        this._s = s
        this._e = e
        this._o = o
        this.nm = nm
        this.m = m
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 9 }
    }

    public prop s: Array<Keyframe<Float64>> {
        get() { this._s.clone() }
    }

    public prop e: Array<Keyframe<Float64>> {
        get() { this._e.clone() }
    }

    public prop o: Array<Keyframe<Float64>> {
        get() { this._o.clone() }
    }

    public func toString(): String {
        return "ShapeTrimPath[tm]: {\n" +
               "ty = ${ty}\n" +
               "s = ${_s}\n" +
               "e = ${_e}\n" +
               "o = ${_o}\n" +
               "nm = ${nm}\n" +
               "m = ${m}\n" +
               "hd = ${hd}\n}"
    }
}
