/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
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

    let ty: String = "rp"

    public init(nm!: String, c!: Array<Keyframe<Float64>>, o!: Array<Keyframe<Float64>>, tr!: AnimatableTransform, hd!: Bool){
        this.nm = nm
        this._c = c
        this._o = o
        this.tr = tr
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 12 }
    }

    public prop c: Array<Keyframe<Float64>> {
        get() { this._c.clone() }
    }

    public prop o: Array<Keyframe<Float64>> {
        get() { this._o.clone() }
    }

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
