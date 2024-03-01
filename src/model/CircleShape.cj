/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class CircleShape <: ContentModel {

    /**
     * 7. "layers"."shapes".{"ty": "el"} = CircleShapeParser
     */
    public let nm: String                                // 0 = name
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    private let _s: Array<Keyframe<PointF>>              // 2 = size
    public let hd: Bool                                  // 3 = hidden
    public let d: Int64                                  // 4 = reversed
    
    let ty: String = "el"

    public init(nm!: String, p!: AnimatableSplitDimensionPathValue, s!: Array<Keyframe<PointF>>, hd!: Bool, d!: Int64){
        this.nm = nm
        this.p = p
        this._s = s
        this.hd = hd
        this.d = d
    }

    public override prop types: Int8 {
        get() { 7 }
    }

    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    public func toString(): String {
        return "CircleShape[el]: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "p = ${p},\n" +
               "s = ${_s},\n" +
               "hd = ${hd},\n" +
               "d = ${d}\n}"
    }
}
