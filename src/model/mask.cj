/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Mask structure.
 */
package model

public class Mask <: ToString {

    public let cl: Bool                             // 0 = cl
    public let inv: Bool                            // 1 = inverted
    public let mode: String                         // 2 = maskMode
    private let _pt: Array<Keyframe<ShapeData>>     // 3 = maskPath
    private let _o: Array<Keyframe<Int64>>          // 4 = opacity
    private let _x: Array<Keyframe<Int64>>          // 5 = x
    public let nm: String                           // 6 = nm

    /**
     * Create a Mask instance based on parameters.
     *
     * @param cl - Type of Bool, the value of cl.
     * @param inv - Type of Bool, the value of inv.
     * @param mode - Type of String, the value of mode.
     * @param pt - Type of Array<Keyframe<ShapeData>>, the value of pt.
     * @param o - Type of Array<Keyframe<Int64>>, the value of o.
     * @param x - Type of Array<Keyframe<Int64>>, the value of x.
     * @param nm - Type of String, the value of nm.
     */
    public init(
        cl!: Bool = false,
        inv!: Bool= false,
        mode!: String = "",
        pt!: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        x!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        nm!: String = ""
    ){
        this.cl = cl
        this.inv = inv
        this.mode = mode
        this._pt = pt
        this._o = o
        this._x = x
        this.nm = nm
    }

    /**
     * Obtain the pt of Mask.
     */
    public prop pt: Array<Keyframe<ShapeData>> {
        get() { this._pt.clone() }
    }

    /**
     * Obtain the o of Mask.
     */
    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    /**
     * Obtain the x of Mask.
     */
    public prop x: Array<Keyframe<Int64>> {
        get() { this._x.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Mask: {\n" +
        "cl    = ${cl}\n" +
        "inv   = ${inv}\n" +
        "mode  = ${mode}\n" +
        "pt    = ${_pt}\n" +
        "o     = ${_o}\n" +
        "x     = ${_x}\n" +
        "nm    = ${nm}\n}"
    }
}
