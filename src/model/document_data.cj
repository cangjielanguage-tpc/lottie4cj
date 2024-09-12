/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a DocumentData structure.
 */
package lottie4cj.model


public class Letter <: Equatable<Letter> {
    public var l: Float64 = 0.0
    public var an: Float64 = 0.0
    public var add: Float64 = 0.0
    public var n: Bool = false
    public var anIndexes: Array<Int64> = Array<Int64>()
    public var val: String = ""
    public var line: Int64 = 0
    public var animatorJustifyOffset: Float64 = 0.0
    public var yOffset: Int64 = 0

    public var ind: Int64 = 0
    public var extra: Float64 = 0.0

    public init(
        l!: Float64 = 0.0,
        an!: Float64 = 0.0,
        add!: Float64 = 0.0,
        n!: Bool = false,
        anIndexes!: Array<Int64> = Array<Int64>(),
        val!: String = "",
        line!: Int64 = 0,
        animatorJustifyOffset!: Float64 = 0.0
    ){
        this.l = l
        this.an = an
        this.add = add
        this.n = n
        this.anIndexes = anIndexes
        this.val = val
        this.line = line
        this.animatorJustifyOffset = animatorJustifyOffset
    }

    public operator func ==(that: Letter): Bool {
        return this.l == that.l &&
               this.an == that.an &&
               this.add == that.add &&
               this.n == that.n &&
               this.anIndexes == that.anIndexes &&
               this.val == that.val &&
               this.line == that.line &&
               this.animatorJustifyOffset == that.animatorJustifyOffset &&
               this.ind == that.ind &&
               this.extra == that.extra
    }

    public operator func !=(that: Letter): Bool {
        return !(this == that)
    }

}

public class DocumentData <: ToString & Equatable<DocumentData> {

    //"layers"."t"."d"
    public var t: String                  // 0  = text
    public var f: String                  // 1  = fontName
    public var s: Float64                 // 2  = size
    public var j: Int64                   // 3  = justification
    public var tr: Int64                  // 4  = tracking
    public var lh: Float64                // 5  = lineHeight
    public var ls: Float64                // 6  = baselineShift
    public var fc: Array<Float64>         // 7  = fillColor
    public var sc: Array<Float64>         // 8  = strokeColor
    public var sw: Float64                // 9  = strokeWidth
    public var of: Bool                   // 10 = strokeOverFill
    public var ps: Array<Float64>         // 11 = boxPosition
    public var sz: Array<Float64>         // 12 = boxSize

    /* 应用于 TextProperty.currentData 中数据结构 */
    public var ascent: Float64 = 0.0
    public var boxWidth: Array<Float64> = Array<Float64>()
    public var fStyle: String = ""
    public var fWeight: String = ""

    public var justifyOffset: Float64 = 0.0
    public var l: ArrayList<Letter> = ArrayList<Letter>()
    public var lineWidths: ArrayList<Float64> = ArrayList<Float64>()

    public var fillColorAnim: Bool = false
    public var strokeColorAnim: Bool = false
    public var strokeWidthAnim: Bool = false
    public var yOffset: Float64 = 0.0
    public var finalSize: Float64 = 0.0
    public var finalText: ArrayList<String> = ArrayList<String>()
    public var finalLineHeight: Float64 = 0.0
    public var __complete: Bool = false



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
    public init(
        t!: String = "",
        f!: String = "",
        s!: Float64 = 0.0,
        j!: Int64 = 0,
        tr!: Int64 = 0,
        lh!: Float64 = 0.0,
        ls!: Float64 = 0.0,
        fc!: Array<Float64> = Array<Float64>(),
        sc!: Array<Float64> = Array<Float64>(),
        sw!: Float64 = 0.0,
        of!: Bool = false,
        ps!: Array<Float64> = Array<Float64>(),
        sz!: Array<Float64> = Array<Float64>()
    ){
        this.t = t
        this.f = f
        this.s = s
        this.j = j
        this.tr = tr
        this.lh = lh
        this.ls = ls
        this.fc = fc
        this.sc = sc
        this.sw = sw
        this.of = of
        this.ps = ps
        this.sz = sz
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
               "fc = ${fc}\n" +
               "sc = ${sc}\n" +
               "sw = ${sw}\n" +
               "of = ${of}\n" +
               "ps = ${ps}\n" +
               "sz = ${sz}\n}"
    }

    public operator func ==(that: DocumentData): Bool {
        return this.t == that.t
               this.f  == that.f &&
               this.s  == that.s &&
               this.j  == that.j &&
               this.tr == that.tr &&
               this.lh == that.lh &&
               this.ls == that.ls &&
               this.fc == that.fc &&
               this.sc == that.sc &&
               this.sw == that.sw &&
               this.of == that.of &&
               this.ps == that.ps &&
               this.sz == that.sz &&

               /* 应用于 TextProperty.currentData 中数据结构 */
               this.ascent   == that.ascent &&
               this.boxWidth == that.boxWidth &&
               this.fStyle   == that.fStyle &&
               this.fWeight  == that.fWeight &&

               this.justifyOffset == that.justifyOffset &&
               this.l == that.l &&
               this.lineWidths == that.lineWidths &&

               this.t == that.t &&
               this.fillColorAnim   == that.fillColorAnim &&
               this.strokeColorAnim == that.strokeColorAnim &&
               this.strokeWidthAnim == that.strokeWidthAnim &&
               this.yOffset   == that.yOffset &&
               this.finalSize == that.finalSize &&
               this.finalText == that.finalText &&
               this.finalLineHeight == that.finalLineHeight &&
               this.__complete == that.__complete
    }

    public operator func !=(that: DocumentData): Bool {
        return !(this == that)
    }

}
