/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
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

    public prop pt: Array<Keyframe<ShapeData>> {
        get() { this._pt.clone() }
    }

    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    public prop x: Array<Keyframe<Int64>> {
        get() { this._x.clone() }
    }

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
