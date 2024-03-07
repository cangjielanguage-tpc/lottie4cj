/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Marker <: ToString {

    public let cm: String             // 0 = comment
    public let tm: Float64            // 1 = frame
    public let dr: Float64            // 2 = durationFrames

    public init(cm: String, tm: Float64, dr: Float64) {
        this.cm = cm
        this.tm = tm
        this.dr = dr
    }

    public func toString(): String {
        "Marker: {\n" +
        "cm = ${cm}\n" +
        "tm = ${tm}\n" +
        "dr = ${dr}\n}"
    }
}
