/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package utils.text

public class MDF {
    var o: Bool = false
    var sw: Bool = false
    var sc: Bool = false
    var fc: Bool = false
    var m: Bool = false
    var p: Bool = false

    init(){}
    init(o!: Bool, sw!: Bool, sc!: Bool, fc!: Bool, m!: Bool, p!: Bool){
        this.o = o
        this.sw = sw
        this.sc = sc
        this.fc = fc
        this.m = m
        this.p = p
    }
}

public class LetterProps {

    var o: Int64 = 0
    var sw: Int64 = 0
    var sc: String = ""
    var fc: String = ""
    var m: String = ""
    var p: Array<Float64> = Array<Float64>()
    var _mdf: MDF = MDF()

    /**
     * Create a LetterProps.
     */
    public init(){}

    /**
     * Create a LetterProps instance based on parameters.
     *
     * @param o - Type of Int64, the value of o.
     * @param sw - Type of Int64, the value of sw.
     * @param sc - Type of String, the value of sc.
     * @param fc - Type of String, the value of fc.
     * @param m - Type of String, the value of m.
     * @param p - Type of Array<Float64>, the value of p.
     */
    /* p => this.props => createTypedArray('float32', 16) */
    public init(o: Int64, sw: Int64, sc: String, fc: String, m: String, p: Array<Float64>) {
        this.o = o
        this.sw = sw
        this.sc = sc
        this.fc = fc
        this.m = m
        this.p = p
        this._mdf = MDF(
            o: true,
            sw: sw != 0,
            sc: sc != "",
            fc: fc != "",
            m: true,
            p: true
        )
    }

    /**
     * Update the LetterProps instance.
     *
     * @param o - Type of Int64, the value of o.
     * @param sw - Type of Int64, the value of sw.
     * @param sc - Type of String, the value of sc.
     * @param fc - Type of String, the value of fc.
     * @param m - Type of String, the value of m.
     * @param p - Type of Array<Float64>, the value of p.
     * @return Type of Bool, the result of update the LetterProps instance.
     */
    public func update(o: Int64, sw: Int64, sc: String, fc: String, m: String, p: Array<Float64>): Bool {
        this._mdf.o = false
        this._mdf.sw = false
        this._mdf.sc = false
        this._mdf.fc = false
        this._mdf.m = false
        this._mdf.p = false
        var updated = false
    
        if (this.o != o) {
            this.o = o
            this._mdf.o = true
            updated = true
        }
        if (this.sw != sw) {
            this.sw = sw
            this._mdf.sw = true
            updated = true
        }
        if (this.sc != sc) {
            this.sc = sc
            this._mdf.sc = true
            updated = true
        }
        if (this.fc != fc) {
            this.fc = fc
            this._mdf.fc = true
            updated = true
        }
        if (this.m != m) {
            this.m = m
            this._mdf.m = true
            updated = true
        }
        if (this.p.size != p.size && (
            (this.p.size > 0 && p.size > 0 && this.p[0] != p[0]) ||
            (this.p.size > 1 && p.size > 1 && this.p[1] != p[1]) ||
            (this.p.size > 4 && p.size > 4 && this.p[4] != p[4]) ||
            (this.p.size > 5 && p.size > 5 && this.p[5] != p[5]) ||
            (this.p.size > 12 && p.size > 12 && this.p[12] != p[12]) ||
            (this.p.size > 13 && p.size > 13 && this.p[13] != p[13])
        )) {
            this.p = p
            this._mdf.p = true
            updated = true
        }
        return updated
    }

}
