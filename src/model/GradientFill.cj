/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class GradientFill <: ContentModel {

    /**
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFillParser
     */
    public let nm: String                        //0 = name

    // "g": {"p": points/Int64, "k": color/Array<Keyframe<T>>}  => Array<Keyframe<Array<Float64>>>
    public let g: ContentModelP                  //1 = {points, color}

    private let _o: Array<Keyframe<Int64>>       //2 = opacity
    public let t: Int64                          //3 = gradientType
    private let _s: Array<Keyframe<PointF>>      //4 = startPoint
    private let _e: Array<Keyframe<PointF>>      //5 = endPoint
    public let r: Int64                          //6 = fillTypeInt
    public let hd: Bool                          //7 = hidden

    let ty: String = "gf"

    public init(nm!: String, g!: ContentModelP, o!: Array<Keyframe<Int64>>, t!: Int64,
        s!: Array<Keyframe<PointF>>, e!: Array<Keyframe<PointF>>, r!: Int64, hd!: Bool
    ){
        this.nm = nm
        this.g = g
        this._o = o
        this.t = t
        this._s = s
        this._e = e
        this.r = r
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 4 }
    }

    public prop o: Array<Keyframe<Int64>> {
        get() { this._o.clone() }
    }

    public prop s: Array<Keyframe<PointF>> {
        get() { this._s.clone() }
    }

    public prop e: Array<Keyframe<PointF>> {
        get() { this._e.clone() }
    }

    public func toString(): String {
        return "GradientFill[gf]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "g = ${g}\n" +
               "o = ${_o}\n" +
               "t = ${t}\n" +
               "s = ${_s}\n" +
               "e = ${_e}\n" +
               "r = ${r}\n" +
               "hd = ${hd}\n}"
    }
}
