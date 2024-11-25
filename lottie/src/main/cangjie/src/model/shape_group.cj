/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeGroup structure.
 */
package lottie.model

public class ShapeGroup <: ContentModel {

    //新增成员变量，解析部分待补充。
    public var np: Int64 = 0
    public var ix: Int64 = 0
    public let mn: String = ""

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroupParser
     */
    public let nm: String                    // 0 = name

    public let it: ArrayList<ContentModel>       // 2 = items

    public var cix: Int64 = 0

    let _ty: String = "gr"
    public open prop ty: String {
        get() { _ty }
    }
    
    /**
     * Create a ShapeGroup instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param it - Type of Array<ContentModel>, the value of it.
     * @param hd - Type of Bool, the value of hd.
     * @param cix - Type of Int64, the value of cix.
     */
    public init(nm!: String, it!: ArrayList<ContentModel>, hd!: Bool = false, cix!: Int64 = 0, np!: Int64 = 0) {
        this.nm = nm
        this.it = it
        this.hd = hd
        this.cix = cix
        this.np = np
    }

    /**
     * Create a ShapeGroup instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param it - Type of Array<ContentModel>, the value of it.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(nm: String, it: ArrayList<ContentModel>, hd: Bool) {
        this.nm = nm
        this.it = it
        this.hd = hd
    }

    public func clone(): ShapeGroup {
        var tmpit = ArrayList<ContentModel>(this.it.size,{i => unsafe {zeroValue<ContentModel>()}})
        for (i in 0..this.it.size) {
            tmpit[i] = this.it[i].clone()
        }
        var sc = ShapeGroup(nm: this.nm, it: tmpit, hd: this.hd, cix: this.cix,np: this.np)
        sc.np = this.np
        sc.ix = this.ix
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
    }

    /**
     * Obtain the type of ShapeGroup.
     */
    public override prop types: Int8 {
        get() { 0 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeGroup[gr]: {\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "hd: ${hd},\n" +
               "it: ${it}\n}"
    }
}
