/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a RoundedCorners structure.
 */
package lottie.model

public class RoundedCorners <: ContentModel {
    //TODO:新增成员变量，解析部分暂未补上。
    public let mn: String = ""

    public var ix: Int64 = -1

    /**
     * 13. "layers"."shapes".{"ty": "rd"} = RoundedCornersParser
     */
    public let nm: String                          // 0
    //"r": {"a": 0, "k": 10, "ix": 1}
    public let r: ArrayKeyframeFloat64             // 1
    //public let hd: Bool                            // 2

    let _ty: String = "rd"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a RoundedCorners instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param r - Type of ArrayKeyframeFloat64, the value of r.
     * @param hd - Type of Bool, the value of hd.
     * @param ix - Type of Int64, the value of ix.
     */
    public init(nm!: String = "", r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(), hd!: Bool = false, ix!: Int64 = -1){
        this.nm = nm
        this.r = r
        this.hd = hd
        this.ix = ix
    }

    /**
     * Obtain the type of RoundedCorners.
     */
    public override prop types: Int8 {
        get() { 13 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "RoundedCorners[rd]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "r = ${r.k}\n" +
               "hd = ${hd}\n}"
    }
}
