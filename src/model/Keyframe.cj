/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Keyframe<T> <: ToString where T <: ToString {

    //"layers"."shapes"."c"."k" == parseColor
    public let k: Option<T>

    //"layers"."shapes"."c"."k"  <==  "layers"."shapes".{"ty": "st"}
    public let t: Float64       // 0

    //s/e => Color     // 1/2
    public let s: Option<T>     // 1
    public let e: Option<T>     // 2

    public let o: PointF        // 3
    public let i: PointF        // 4
    public let h: Int64         // 5
    public let to: PointF       // 6
    public let ti: PointF       // 7

    public init(
        k!: Option<T> = Option<T>.None,
        t!: Float64 = 0.0,
        s!: Option<T> = Option<T>.None,
        e!: Option<T> = Option<T>.None,
        o!: PointF = PointF(),
        i!: PointF = PointF(),
        h!: Int64 = 0,
        to!: PointF = PointF(),
        ti!: PointF = PointF()
    ){
        this.k = k
        this.t = t
        this.s = s
        this.e = e
        this.o = o
        this.i = i
        this.h = h
        this.to = to
        this.ti = ti
    }

    public func toString(): String {
        let strk: String = match (k) {
            case Some(v) => v.toString()
            case None => "None"
        }
        let strs: String = match (s) {
            case Some(v) => v.toString()
            case None => "None"
        }
        let stre: String = match (e) {
            case Some(v) => v.toString()
            case None => "None"
        }

        return "Keyframe{\n" +
               "k = ${strk}\n" +
               "t = ${t}\n" +
               "s = ${strs}\n" +
               "e = ${stre}\n" +
               "o = ${o}\n" +
               "i = ${i}\n" +
               "h = ${h}\n" +
               "to = ${to}\n" +
               "ti = ${ti}\n}"
    }
}
