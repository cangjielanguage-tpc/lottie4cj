/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

import lottie4cj.utils.helpers.*
//TODO data类型
public class SVGStyleData {

    var data: Datas
    var types: String
    var d: String
    var lvl: Int64
    var _mdf: Bool
    var closed: Bool
    var pElem: CreateNS
    var msElem: Option<CreateNS>

    public init(data: Datas, level: Int64) {
        this.data = data
        this.types = data.ty
        this.d = ""
        this.lvl = level
        this._mdf = false
        this.closed = (data.hd == true)
        this.pElem = CreateNS("path")
        this.msElem = None
    }

    public func reset() {
        this.d = ""
        this._mdf = false
    }
}