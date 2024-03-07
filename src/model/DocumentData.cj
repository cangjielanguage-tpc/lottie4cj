/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class DocumentData <: ToString {

    //"layers"."t"."d"
    public let t: String                  // 0  = text
    public let f: String                  // 1  = fontName
    public let s: Float64                 // 2  = size
    public let j: Int64                   // 3  = justification
    public let tr: Int64                  // 4  = tracking
    public let lh: Float64                // 5  = lineHeight
    public let ls: Float64                // 6  = baselineShift
    private let _fc: Array<Float64>       // 7  = fillColor
    private let _sc: Array<Float64>       // 8  = strokeColor
    public let sw: Float64                // 9  = strokeWidth
    public let of: Bool                   // 10 = strokeOverFill
    public let ps: PointF                 // 11 = boxPosition
    public let sz: PointF                 // 12 = boxSize

    public init(t!: String, f!: String, s!: Float64, j!: Int64, tr!: Int64, lh!: Float64, ls!: Float64,
        fc!: Array<Float64>, sc!: Array<Float64>, sw!: Float64, of!: Bool, ps!: PointF, sz!: PointF
    ){
        this.t = t
        this.f = f
        this.s = s
        this.j = j
        this.tr = tr
        this.lh = lh
        this.ls = ls
        this._fc = fc
        this._sc = sc
        this.sw = sw
        this.of = of
        this.ps = ps
        this.sz = sz
    }

    public prop fc: Array<Float64> {
        get() { this._fc.clone() }
    }

    public prop sc: Array<Float64> {
        get() { this._sc.clone() }
    }

    public func toString(): String {
        return "DocumentData: {\n" +
               "t = ${t}\n" +
               "f = ${f}\n" +
               "s = ${s}\n" +
               "j = ${j}\n" +
               "tr = ${tr}\n" +
               "lh = ${lh}\n" +
               "ls = ${ls}\n" +
               "fc = ${_fc}\n" +
               "sc = ${_sc}\n" +
               "sw = ${sw}\n" +
               "of = ${of}\n" +
               "ps = ${ps}\n" +
               "sz = ${sz}\n}"
    }
}
