/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a PolystarShape structure.
 */
package lottie4cj.model

public class PolystarShape <: ContentModel {

    public var ix: Int64 = -1

    /**
     * 10. "layers"."shapes".{"ty": "sr"} = PolystarShapeParser
     */
    public let nm: String                                 // 0  = name
    public let sy: Int64                                  // 1  = type
    //"pt":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[5]},{"t":59,"s":[6]}],"ix":3}
    public let pt: ArrayKeyframeFloat64                   // 2  = points
    //"p":{"a":1,"k":[{"i":{"x":0.833,"y":0.833},"o":{"x":0.167,"y":0.167},"t":0,"s":[0,0],"to":[0.833,1.333],"ti":[-0.833,-1.333]},{"t":59,"s":[5,8]}],"ix":4}
    public let p: AnimatableSplitDimensionPathValue       // 3  = position
    //"r":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[187.839]},{"t":59,"s":[204.839]}],"ix":5}
    public let r: ArrayKeyframeFloat64                    // 4  = rotation
    //"or":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[109.981]},{"t":59,"s":[123.981]}],"ix":7}
    public let or: ArrayKeyframeFloat64                    // 5  = outerRadius
    //"os":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[0]},{"t":59,"s":[40]}],"ix":9}
    public let os: ArrayKeyframeFloat64                    // 6  = outerRoundedness
    //"ir":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[54.99]},{"t":59,"s":[61.99]}],"ix":6},
    public let ir: ArrayKeyframeFloat64                    // 7  = innerRadius
    //"is":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[0]},{"t":59,"s":[5]}],"ix":8},
    public let is2: ArrayKeyframeFloat64                    // 8  = innerRoundedness
    public let hd: Bool                                     // 9  = hidden
    public let d: Int64                                     // 10 = reversed

    let _ty: String = "sr"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a PolystarShape instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param sy - Type of Int64, the value of sy.
     * @param pt - Type of ArrayKeyframeFloat64, the value of pt.
     * @param p - Type of AnimatableSplitDimensionPathValue, the value of p.
     * @param r - Type of ArrayKeyframeFloat64, the value of r.
     * @param or - Type of ArrayKeyframeFloat64, the value of or.
     * @param os - Type of ArrayKeyframeFloat64, the value of os.
     * @param ir - Type of ArrayKeyframeFloat64, the value of ir.
     * @param is2 - Type of ArrayKeyframeFloat64, the value of is.
     * @param hd - Type of Bool, the value of hd.
     * @param d - Type of Int64, the value of d.
     * @param ix - Type of Int64, the value of ix.
     */
    public init(
        nm!: String = "",
        sy!: Int64 = 0,
        pt!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        or!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        os!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        ir!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        is2!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        hd!: Bool = false,
        d!: Int64 = 0,
        ix!: Int64 = -1
    ){
        this.nm = nm
        this.sy = sy
        this.pt = pt
        this.p = p
        this.r = r
        this.or = or
        this.os = os
        this.ir = ir
        this.is2 = is2
        this.hd = hd
        this.d = d
        this.ix = ix
    }

    /**
     * Obtain the type of PolystarShape.
     */
    public override prop types: Int8 {
        get() { 10 }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "PolystarShape[sr]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "sy = ${sy}\n" +
               "pt = ${pt.k}\n" +
               "p = ${p}\n" +
               "r = ${r.k}\n" +
               "or = ${or.k}\n" +
               "os = ${os.k}\n" +
               "ir = ${ir.k}\n" +
               "is2 = ${is2.k}\n" +
               "hd = ${hd}\n" +
               "d = ${d}\n}"
    }
}
