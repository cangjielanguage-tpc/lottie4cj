/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements.helpers.shapes


public open class SVGNoStyleData {

    public var style: SVGStyleData
    public var gf: CreateNS = CreateNS("")
    public var ms: CreateNS = CreateNS("")
    public var of: CreateNS = CreateNS("")
    public var maskId: String = ""
    public init(elem: Object, data: Datas, styleOb: SVGStyleData) {
       this.style = styleOb
    }
}