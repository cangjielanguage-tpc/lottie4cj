/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapeFill <: ContentModel {

    /**
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
     */
    public let nm: String                               // 0 = name
    private let _c: Array<Keyframe<Array<Float64>>>     // 1 = color
    private let _o: Array<Keyframe<Int64>>              // 2 = opacity
    public let fillEnabled: Bool                        // 3 = fillEnabled
    public let r: Int64                                 // 4 = fillTypeInt
    public let hd: Bool                                 // 5 = hidden

    let ty: String = "fl"

    public init(nm!: String, c!: Array<Keyframe<Array<Float64>>>, o!: Array<Keyframe<Int64>>,
         fillEnabled!: Bool, r!: Int64, hd!: Bool
    ){
        this.nm = nm
        this._c = c
        this._o = o
        this.fillEnabled = fillEnabled
        this.r = r
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 3 }
    }

    public prop c: Array<Keyframe<Array<Float64>>> {
        get() { this._c.clone() }
    }

    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    public func toString(): String {
        return "ShapeFill[fl]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${_c}\n" +
               "o = ${_o}\n" +
               "fillEnabled = ${fillEnabled}\n" +
               "r = ${r}\n" +
               "hd = ${hd}\n}"
    }
}
