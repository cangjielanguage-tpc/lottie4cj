/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class RectangleShape <: ContentModel {

    /**
     * 8. "layers"."shapes".{"ty": "rc"} = RectangleShapeParser
     */
    public let nm: String                                // 0 = name
    public let p: AnimatableSplitDimensionPathValue      // 1 = position
    private let _s: Array<Keyframe<PointF>>              // 2 = size
    private let _r: Array<Keyframe<Float64>>             // 3 = roundedness
    public let hd: Bool                                  // 4 = hidden

    let ty: String = "rc"

    public init(
        nm!: String = "",
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        hd!: Bool = false
    ){
        this.nm = nm
        this.p = p
        this._s = s
        this._r = r
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 8 }
    }

    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    public prop r: Array<Keyframe<Float64>> {
        get() { this._r.clone() }
    }

    public func toString(): String {
        return "RectangleShape[rc]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "p = ${p}\n" +
               "s = ${_s}\n" +
               "r = ${_r}\n" +
               "hd = ${hd}\n}"
    }
}
