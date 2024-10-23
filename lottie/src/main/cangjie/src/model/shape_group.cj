/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeGroup structure.
 */
package lottie.model

public class ShapeGroup <: ContentModel {

    //TODO:新增成员变量，解析部分暂未补上。
    public var np: Int64 = 0
    public var ix: Int64 = 0
    public let mn: String = ""

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroupParser
     */
    public let nm: String                    // 0 = name
    //public let hd: Bool                      // 1 = hidden
    private let _it: Array<ContentModel>     // 2 = items

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
    public init(nm!: String, it!: Array<ContentModel>, hd!: Bool = false, cix!: Int64 = 0, np!: Int64 = 0) {
        this.nm = nm
        this._it = it
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
    public init(nm: String, it: Array<ContentModel>, hd: Bool) {
        this.nm = nm
        this._it = it
        this.hd = hd
    }

    /**
     * Obtain the type of ShapeGroup.
     */
    public override prop types: Int8 {
        get() { 0 }
    }

    /**
     * Obtain the it of ShapeGroup.
     */
    public prop it: Array<ContentModel> {
        get() { this._it.clone() }
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
               "it: ${_it}\n}"
    }
}
