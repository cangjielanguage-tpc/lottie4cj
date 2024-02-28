/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Marker <: ToString {

    var cm: String = ""     // 0 = comment
    var tm: Float64 = 0.0   // 1 = frame
    var dr: Float64 = 0.0   // 2 = durationFrames

    init(){}
    init(cm: String, tm: Float64, dr: Float64) {
        this.cm = cm
        this.tm = tm
        this.dr = dr
    }

    public func toString(): String {
        "Marker: {\n" +
        "    cm = ${cm}\n" +
        "    tm = ${tm}\n" +
        "    dr = ${dr}\n" +
        "}\n"
    }
}
