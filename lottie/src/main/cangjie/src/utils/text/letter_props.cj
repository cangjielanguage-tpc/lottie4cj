/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.text
internal import ohos.base.*
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
//Color
    var o: Int64 = 0
    public var sw: Int64 = 0
    public var sc: Color = Color(0,0,0)
    public var fc: Color = Color(0,0,0)
    var m: String = ""
    var p: Array<Float64> = Array<Float64>()
    var _mdf: MDF = MDF()

    public init(){}

    //p => this.props = createTypedArray('float32', 16)
    //public LetterProps(o: Int64, sw: Int64, sc: String, fc: String, m: String, p: Array<Float64>) {
    public init(o: Int64, sw: Int64, sc: Color, fc: Color, m: String, p: Array<Float64>) {
        this.o = o
        this.sw = sw
        this.sc = sc
        this.fc = fc
        this.m = m
        this.p = p
        this._mdf = MDF(
            o: true,
            sw: sw != 0,
            sc: sc.toUInt32() != this.sc.toUInt32(),
            fc: fc.toUInt32() != this.fc.toUInt32(),
            m: true,
            p: true
        )
    }

    func update(o: Int64, sw: Int64, sc: Color, fc: Color, m: String, p: Array<Float64>) {
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
        if (this.sc.toUInt32() != sc.toUInt32()) {
            this.sc = sc
            this._mdf.sc = true
            updated = true
        }
        if (this.fc.toUInt32() != fc.toUInt32()) {
            this.fc = fc
            this._mdf.fc = true
            updated = true
        }
        if (this.m != m) {
            this.m = m
            this._mdf.m = true
            updated = true
        }
        //TODO: 注意数组越界问题
        if (this.p.size != p.size && (this.p[0] != p[0] || this.p[1] != p[1] || this.p[4] != p[4] || this.p[5] != p[5] || this.p[12] != p[12] || this.p[13] != p[13])) {
            this.p = p
            this._mdf.p = true
            updated = true
        }
        return updated
    }

}
