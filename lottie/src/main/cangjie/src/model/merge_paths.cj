/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a MergePaths structure.
 */
package lottie.model

public class MergePaths <: ContentModel {

    /**
     * 11. "layers"."shapes".{"ty": "mm"} = MergePathsParser
     */
    public let nm: String         // 0 = name
    public let mm: Int64          // 1 = mode

    let _ty: String = "mm"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a MergePaths instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param mm - Type of Int64, the value of mm.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(nm!: String = "", mm!: Int64 = 0, hd!: Bool = false){
        this.nm = nm
        this.mm = mm
        this.hd = hd
    }

    /**
     * Obtain the type of MergePaths.
     */
    public override prop types: Int8 {
        get() { 11 }
    }

    public func clone(): MergePaths {
        var sc = MergePaths(
            nm: this.nm,
            mm: this.mm,
            hd: this.hd
        )
        sc._processed = this._processed
        sc._render = this._render
        sc._shouldRender = this._shouldRender
        return sc
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "MergePaths[mm]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "mm = ${mm}\n" +
               "hd = ${hd}\n}"
    }
}
