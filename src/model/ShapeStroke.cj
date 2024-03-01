/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapeStroke <: ContentModel {

    /**
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStrokeParser
     */
    public let nm: String                              // 0 = name
    private let _c: Array<Keyframe<Array<Float64>>>    // 1 = color
    private let _w: Array<Keyframe<Float64>>           // 2 = width
    private let _o: Array<Keyframe<Int64>>             // 3 = opacity
    public let lc: Int64                               // 4 = capType
    public let lj: Int64                               // 5 = joinType
    public let ml: Float64                             // 6 = miterLimit
    public let hd: Bool                                // 7 = hidden
    private let _d: Array<ContentModelD>               // 8 = lineDashPattern
    //"d": [{"n": "String "v": Array<Keyframe<T>>}]

    let ty: String = "st"

    public init(nm!: String, c!: Array<Keyframe<Array<Float64>>>, w!: Array<Keyframe<Float64>>, o!: Array<Keyframe<Int64>>,
        lc!: Int64, lj!: Int64, ml!: Float64, hd!: Bool, d!: Array<ContentModelD>
    ){
        this.nm = nm
        this._c = c
        this._w = w
        this._o = o
        this.lc = lc
        this.lj = lj
        this.ml = ml
        this.hd = hd
        this._d = d
    }

    public override prop types: Int8 {
        get() { 1 }
    }

    public prop c: Array<Keyframe<Array<Float64>>> {
        get() { this._c.clone() }
    }

    public prop w: Array<Keyframe<Float64>> {
        get() { this._w.clone() }
    }

    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    public prop d: Array<ContentModelD> {
        get() { this._d.clone() }
    }

    public func toString(): String {
        return "ShapeStroke[st]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${_c}\n" +
               "w = ${_w}\n" +
               "o = ${_o}\n" +
               "lc = ${lc}\n" +
               "lj = ${lj}\n" +
               "ml = ${ml}\n" +
               "hd = ${hd}\n" +
               "d = ${_d}\n}"
    }

}
