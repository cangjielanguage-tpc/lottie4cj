/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class GradientStroke <: ContentModel {

    /**
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStrokeParser
     */
    public let nm: String                       //0 = name

    // "g": {"p": points/Int64, "k": color/Array<Keyframe<T>>} => Array<Keyframe<Array<Float64>>>
    public let g: ContentModelP                 //1 = {points, color}

    private let _o: Array<Keyframe<Int64>>      //2 = opacity
    public let t: Int64                         //3 = gradientType
    private let _s: Array<Keyframe<PointF>>     //4 = startPoint
    private let _e: Array<Keyframe<PointF>>     //5 = endPoint
    private let _w: Array<Keyframe<Float64>>    //6 = width
    public let lc: Int64                        //7 = capType
    public let lj: Int64                        //8 = joinType
    public let ml: Float64                      //9 = miterLimit
    public let hd: Bool                         //10 = hidden

    //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  =>  Array<ContentModelD>
    public let d: Array<ContentModelD>      //11 = lineDashPattern

    let ty: String = "gs"

    public init(nm!: String, g!: ContentModelP, o!: Array<Keyframe<Int64>>, t!: Int64,
        s!: Array<Keyframe<PointF>>, e!: Array<Keyframe<PointF>>, w!: Array<Keyframe<Float64>>,
        lc!: Int64, lj!: Int64, ml!: Float64, hd!: Bool, d!: Array<ContentModelD>
    ){
        this.nm = nm
        this.g = g
        this._o = o
        this.t = t
        this._s = s
        this._e = e
        this._w = w
        this.lc = lc
        this.lj = lj
        this.ml = ml
        this.hd = hd
        this.d = d
    }

    public override prop types: Int8 {
        get() { 2 }
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

    public prop w: Array<Keyframe<Float64>> {
        get() { this._w.clone() }
    }

    public func toString(): String {
        return "GradientStroke[gs]: {\n" +
                "ty = ${ty}\n" +
                "nm = ${nm}\n" +
                "g = ${g}\n" +
                "o = ${_o}\n" +
                "t = ${t}\n" +
                "s = ${_s}\n" +
                "e = ${_e}\n" +
                "w = ${_w}\n" +
                "lc = ${lc}\n" +
                "lj = ${lj}\n" +
                "ml = ${ml}\n" +
                "hd = ${hd}\n" +
                "d = ${d}\n}"
    }

}
