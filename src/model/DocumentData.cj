/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a DocumentData structure.
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

    /**
     * Create a DocumentData instance based on parameters.
     *
     * @param t - Type of String, the value of t.
     * @param f - Type of String, the value of f.
     * @param s - Type of Float64, the value of s.
     * @param j - Type of Int64, the value of j.
     * @param tr - Type of Int64, the value of tr.
     * @param lh - Type of Float64, the value of lh.
     * @param ls - Type of Float64, the value of ls.
     * @param fc - Type of Array<Float64>, the value of fc.
     * @param sc - Type of Array<Float64>, the value of sc.
     * @param sw - Type of Float64, the value of sw.
     * @param of - Type of Bool, the value of of.
     * @param ps - Type of PointF, the value of ps.
     * @param sz - Type of PointF, the value of sz.
     */
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

    /**
     * Obtain the fc of DocumentData.
     */
    public prop fc: Array<Float64> {
        get() { this._fc.clone() }
    }

    /**
     * Obtain the sc of DocumentData.
     */
    public prop sc: Array<Float64> {
        get() { this._sc.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
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
