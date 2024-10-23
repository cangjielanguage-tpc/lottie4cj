/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a CircleShape structure.
 */
package lottie.model

public class CircleShape <: ContentModel {
    //TODO:新增成员变量，解析部分暂未补上。
    public let mn: String = ""

    //TODO：循环依赖
    //TODO: ShapeExpressionInterface 中编译用。
    //public var sh: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer())

    /**
     * 7. "layers"."shapes".{"ty": "el"} = CircleShapeParser
     */
    public let nm: String                                // 0 = name
    //"p": {"a": 0, "k": [0, 0], "ix": 3}
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    //"s": {"a": 0, "k": [332.711, 332.711], "ix": 2}
    public let s: ArrayKeyframePointF                    // 2 = size
    //public let hd: Bool                                  // 3 = hidden
    public let d: Int64                                  // 4 = reversed
    
    //TODO: 编译用，在 json 中没有找到 ix 字段。
    public var ix: Int64 = -1

    let _ty: String = "el"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a CircleShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param s - Type of ArrayKeyframePointF, the value of s.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Int64, the value of d.
     */
    public init(
        nm!: String = "",
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: ArrayKeyframePointF = ArrayKeyframePointF(),
        hd!: Bool = false,
        d!: Int64 = 0
    ){
        this.nm = nm
        this.p = p
        this.s = s
        this.hd = hd
        this.d = d
    }

    /**
     * Obtain the type of CircleShape.
     */
    public override prop types: Int8 {
        get() { 7 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "CircleShape[el]: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "p = ${p},\n" +
               "s = ${s.k},\n" +
               "hd = ${hd},\n" +
               "d = ${d}\n}"
    }
}
