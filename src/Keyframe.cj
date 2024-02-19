/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj


from encoding import json.*
from std import collection.*
from std import math.*

public class Keyframe<T> <: ToString {


    //"layers"."shapes"."c"."k" == parseColor
    var k: Option<T> = Option<T>.None

    //"layers"."shapes"."c"."k"  <==  "layers"."shapes".{"ty": "st"}
    var t: Float64 = 0.0         // 0

    //var s/e: Color = Color()     // 1/2
    var s: Option<T> = Option<T>.None     // 1
    var e: Option<T> = Option<T>.None     // 2

    var o: PointF = PointF()    // 3
    var i: PointF = PointF()    // 4
    var h: Int64 = 0           // 5
    var to: PointF = PointF()   // 6
    var ti: PointF = PointF()   // 7

    init(k: T){
        this.k = k
    }

    init(){}

    public func toString(): String {
        ""
    }

}
