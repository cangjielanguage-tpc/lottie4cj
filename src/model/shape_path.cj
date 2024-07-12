/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapePath structure.
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

    let _ty: String = "sh"
    public open prop ty: String {
        get() { _ty }
    }

    var ix: Int64 = 0

    /**
     * Create a ShapePath instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param ind - Type of Int64, the value of ind.
     * @param ks - Type of Array<Keyframe<ShapeData>>, the value of ks.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        nm!: String = "",
        ind!: Int64 = 0,
        ks!: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>(),
        hd!: Bool = false
    ){
        this.nm = nm
        this.ind = ind
        this._ks = ks
        this.hd = hd
    }

    /**
     * Obtain the type of ShapePath.
     */
    public override prop types: Int8 {
        get() { 6 }
    }

    /**
     * Obtain the ks of ShapePath.
     */
    public prop ks: Array<Keyframe<ShapeData>> {
        get() { this._ks.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapePath[sh]: {\n" +
               "ind: ${ind},\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "ks: ${_ks},\n" +
               "hd: ${hd}\n}"
    }
}
