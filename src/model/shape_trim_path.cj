/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeTrimPath structure.
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

    let _ty: String = "tm"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a ShapeTrimPath instance based on parameters.
     *
     * @param s - Type of Array<Keyframe<Float64>>, the value of s.
     * @param e - Type of Array<Keyframe<Float64>>, the value of e.
     * @param o - Type of Array<Keyframe<Float64>>, the value of o.
     * @param nm - Type of String, the value of nm.
     * @param m - Type of Int64, the value of m.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        s!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        e!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        o!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        nm!: String = "",
        m!: Int64 = 0,
        hd!: Bool = false
    ){
        this._s = s
        this._e = e
        this._o = o
        this.nm = nm
        this.m = m
        this.hd = hd
    }

    /**
     * Obtain the type of ShapeTrimPath.
     */
    public override prop types: Int8 {
        get() { 9 }
    }

    /**
     * Obtain the s of ShapeTrimPath.
     */
    public prop s: Array<Keyframe<Float64>> {
        get() { this._s.clone() }
    }

    /**
     * Obtain the e of ShapeTrimPath.
     */
    public prop e: Array<Keyframe<Float64>> {
        get() { this._e.clone() }
    }

    /**
     * Obtain the o of ShapeTrimPath.
     */
    public prop o: Array<Keyframe<Float64>> {
        get() { this._o.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
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
