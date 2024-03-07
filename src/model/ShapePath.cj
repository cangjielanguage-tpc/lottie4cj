/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapePath <: ContentModel {

    /**
     * 6. "layers"."shapes".{"ty": "sh"} = ShapePathParser
     */
    public let nm: String                          //0 = name
    public let ind: Int64                          //1 = ind
    private let _ks: Array<Keyframe<ShapeData>>    //2 = shape
    public let hd: Bool                            //3 = hidden

    let ty: String = "sh"

    public init(nm!: String, ind!: Int64, ks!: Array<Keyframe<ShapeData>>, hd!: Bool){
        this.nm = nm
        this.ind = ind
        this._ks = ks
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 6 }
    }

    public prop ks: Array<Keyframe<ShapeData>> {
        get() { this._ks.clone() }
    }

    public func toString(): String {
        return "ShapePath[sh]: {\n" +
               "ind: ${ind},\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "ks: ${_ks},\n" +
               "hd: ${hd}\n}"
    }
}
