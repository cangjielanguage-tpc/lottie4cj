/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Mask <: ToString {

    var cl: Bool = false       // 0 = cl
    var inv: Bool = false      // 1 = inverted
    var mode: String = ""      // 2 = maskMode
    var pt: ArrayList<Keyframe<ShapeData>> = ArrayList<Keyframe<ShapeData>>()   // 3 = maskPath
    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()            // 4 = opacity
    var x: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()            // 5 = x
    var nm: String = ""        // 6 = nm

    init(){}
    init(cl: Bool, inv: Bool, mode: String, pt: ArrayList<Keyframe<ShapeData>>, o: ArrayList<Keyframe<Int64>>, x: ArrayList<Keyframe<Int64>>, nm: String){
        this.cl = cl
        this.inv = inv
        this.mode = mode
        this.pt = pt
        this.o = o
        this.x = x
        this.nm = nm
    }

    public func toString(): String {
        "Mask: {\n" +
        "cl    = ${cl}\n" +
        "inv   = ${inv}\n" +
        "mode  = ${mode}\n" +
        "pt    = ${pt}\n" +
        "o     = ${o}\n" +
        "x     = ${x}\n" +
        "nm    = ${nm}\n" +
        "}\n"
    }
}
