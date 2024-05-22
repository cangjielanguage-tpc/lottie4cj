/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Repeater structure.
 */
package model

public class Repeater <: ContentModel {

    /**
     * 12. "layers"."shapes".{"ty": "rp"} = RepeaterParser
     */
    public let nm: String                          // 0 = name
    private let _c: Array<Keyframe<Float64>>       // 1 = copies
    private let _o: Array<Keyframe<Float64>>       // 2 = offset
    public let tr: AnimatableTransform             // 3 = transform
    public let hd: Bool                            // 4 = hidden

    let _ty: String = "rp"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a Repeater instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param c - Type of Array<Keyframe<Float64>>, the value of c.
     * @param o - Type of Array<Keyframe<Float64>>, the value of o.
     * @param tr - Type of AnimatableTransform, the value of tr.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        nm!: String = "",
        c!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        o!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        tr!: AnimatableTransform = AnimatableTransform(),
        hd!: Bool = false
    ){
        this.nm = nm
        this._c = c
        this._o = o
        this.tr = tr
        this.hd = hd
    }

    /**
     * Obtain the type of Repeater.
     */
    public override prop types: Int8 {
        get() { 12 }
    }

    /**
     * Obtain the c of Repeater.
     */
    public prop c: Array<Keyframe<Float64>> {
        get() { this._c.clone() }
    }

    /**
     * Obtain the o of Repeater.
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
        return "Repeater[rp]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${_c}\n" +
               "o = ${_o}\n" +
               "tr = ${tr}\n" +
               "hd = ${hd}\n}"
    }
}
