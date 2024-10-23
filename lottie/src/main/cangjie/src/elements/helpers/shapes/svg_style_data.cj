/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements.helpers.shapes

//TODO data类型
public class SVGStyleData {

    public var data: Datas
    public var types: String
    public var d: String
    public var lvl: Int64
    public var _mdf: Bool
    public var closed: Bool
    public var pElem: CreateNS
    public var msElem: Option<CreateNS>

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