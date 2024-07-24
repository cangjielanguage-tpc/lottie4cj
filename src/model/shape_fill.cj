/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeFill structure.
 */
package lottie4cj.model

public class ShapeFill <: ContentModel {

    //将 ShapeFill._c 的值再次加工处理，保存在 c_k 中
    public var c_k: Array<KeyframeArrayFloat64> = Array<KeyframeArrayFloat64>()    // 1 = color
    
    /**
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
     */
    public let nm: String                               // 0 = name
    private let _c: Array<Keyframe<Array<Float64>>>     // 1 = color
    private let _o: Array<Keyframe<Int64>>              // 2 = opacity
    public let fillEnabled: Bool                        // 3 = fillEnabled
    public let r: Int64                                 // 4 = fillTypeInt
    public let hd: Bool                                 // 5 = hidden

    let _ty: String = "fl"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a ShapeFill instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param c - Type of Array<Keyframe<Array<Float64>>>, the value of c.
     * @param o - Type of Array<Keyframe<Int64>>, the value of o.
     * @param fillEnabled - Type of Bool, the value of fillEnabled.
     * @param r - Type of Int64, the value of r.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(
        nm!: String = "",
        c!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        fillEnabled!: Bool = false,
        r!: Int64 = 0,
        hd!: Bool = false
    ){
        this.nm = nm
        this._c = c
        this._o = o
        this.fillEnabled = fillEnabled
        this.r = r
        this.hd = hd
    }

    /**
     * Obtain the type of ShapeFill.
     */
    public override prop types: Int8 {
        get() { 3 }
    }

    /**
     * Obtain the c of ShapeFill.
     */
    public prop c: Array<Keyframe<Array<Float64>>> {
        get() { this._c.clone() }
    }

    /**
     * Obtain the o of ShapeFill.
     */
    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
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
