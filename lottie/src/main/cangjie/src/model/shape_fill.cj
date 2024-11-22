/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeFill structure.
 */
package lottie.model

public class ShapeFill <: FillStroke {

    //新增成员变量，解析部分待补充。
    public let mn: String = ""

    //将原来的 ShapeFill.c，储存到 c_k 中；将再次加工处理的数据，储存到 ShapeFill.c
    public var c_k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
    
    /**
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
     * 
     * 0 = nm = name
     * 1 = c = color
     * 2 = o = opacity
     * 3 = fillEnabled = fillEnabled
     * 4 = r = fillTypeInt
     * 5 = hd = hidden
     */
    public let nm: String                               // 0 = nm = name
    public let fillEnabled: Bool                        // 3 = fillEnabled = fillEnabled

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
        this.c = c
        this.c_k = c
        this.o = o
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
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeFill[fl]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "c = ${c}\n" +
               "o = ${o}\n" +
               "fillEnabled = ${fillEnabled}\n" +
               "r = ${r}\n" +
               "hd = ${hd}\n}"
    }
}
