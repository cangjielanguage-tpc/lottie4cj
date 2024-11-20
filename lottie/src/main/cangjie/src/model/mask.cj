/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Mask structure.
 */
package lottie.model


//Mask 不是 layer.shapes 中的类型，但是处理 layer.shapes 部分逻辑会涉及 Mask，所以空继承 ContentModel。
public class Mask <: ContentModel {

    public let cl: Bool                             // 0 = cl
    public let inv: Bool                            // 1 = inverted
    public let mode: String                         // 2 = maskMode
    public let pt: Array<Keyframe<ShapeData>>     // 3 = maskPath   //走PropertyFactory.getProp中 0 分支逻辑
    public let o: Array<Keyframe<Int64>>          // 4 = opacity
    public let x: Array<Keyframe<Int64>>          // 5 = x
    public let nm: String                           // 6 = nm

    public open prop ty: String {
        get() { "Mask" }
    }
    
    /**
     * Obtain the type of Mask.
     */
    public override prop types: Int8 {
        get() { 20 }
    }
    
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
        this.pt = pt
        this.o = o
        this.x = x
        this.nm = nm
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
        "pt    = ${pt}\n" +
        "o     = ${o}\n" +
        "x     = ${x}\n" +
        "nm    = ${nm}\n}"
    }
}
