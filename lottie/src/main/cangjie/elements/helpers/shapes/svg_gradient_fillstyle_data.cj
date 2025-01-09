/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements.helpers.shapes

import std.collection.*

import lottie.utils.*
import lottie.inner.*

public class SVGGradientFillStyleData <: SVGNoStyleData{

    var g: ElementDatag = ElementDatag()
    var stops: ArrayList<CreateNS> = ArrayList<CreateNS>()
    var cst: ArrayList<CreateNS> = ArrayList<CreateNS>()
    var ost: ArrayList<CreateNS> = ArrayList<CreateNS>()
    public init(elem: Object, data: Datas, styleOb: SVGStyleData) {
        super(elem,data,styleOb)
    }

    public func initGradientData(elem: Object, data: Datas, styleOb: Object) {
    }

    public func setGradientData(pathElement: CreateNS, data: Datas) {
        var gradientId: String = CreateElementID.createID()
        var gfill = if (data.t == 1) {
            CreateNS("linearGradient")
        }else {
            CreateNS("radialGradient")
        }
        gfill.setAttribute("id", gradientId)
        gfill.setAttribute("spreadMethod", "pad")
        gfill.setAttribute("gradientUnits", "userSpaceOnUse")
        var stops = ArrayList<CreateNS>()
        var stop: CreateNS
        var jLen = data.g.p * 4
        for (j in 0..jLen:4) {
            stop = CreateNS("stop")
            gfill.appendChild(stop)
            stops.append(stop)
        }

        if (data.ty == "gf") {
            pathElement.setAttribute("fill" , "url(" + "" + "#" + gradientId + ")")
        }else {
            pathElement.setAttribute("stroke", "url(" + "" + "#" + gradientId + ")")
        }
        this.gf = gfill
        this.cst = stops
    }

    /* 未完全实现 */
    public func setGradientOpacity(data: Datas, styleOb: Object) {
        if (this.g._hasOpacity!= 0 && !this.g._collapsable) {
            var stop: CreateNS
            var mask = CreateNS("mask")
            var maskElement = CreateNS("path")
            mask.appendChild(maskElement)
            var opacityId = CreateElementID.createID()
            var maskId = CreateElementID.createID()
            mask.setAttribute("id", maskId)
            var opFill = if (data.t == 1) {
                CreateNS("linearGradient")
            }else {
                CreateNS("radialGradient")
            }
            opFill.setAttribute("id", opacityId)
            opFill.setAttribute("spreadMethod", "pad")
            opFill.setAttribute("gradientUnits", "userSpaceOnUse")

            var jLen = 10
            var stops = this.stops
            for (j in data.g.p * 4..jLen:2) {
                stop = CreateNS("stop")
                stop.setAttribute("stop-color", "rgb(255,255,255)")
                opFill.appendChild(stop)
                stops.append(stop)
            }
            if (data.ty == "gf") {

                maskElement.setAttribute("fill" , "url(" + "" + "#" + opacityId + ")")
            }else{
                maskElement.setAttribute("stroke", "url(" + "" + "#" + opacityId + ")")
            }
            if (data.ty == "gs") {
                if (data.lc != 0) {
                    maskElement.setAttribute("stroke-linecap", lineCapEnum[data.lc])
                }else {
                    maskElement.setAttribute("stroke-linecap", lineCapEnum[2])
                }
                if (data.lj != 0) {
                    maskElement.setAttribute("stroke-linejoin", lineJoinEnum[data.lj])
                }else {
                    maskElement.setAttribute("stroke-linejoin", lineJoinEnum[2])
                }
                if (data.lj == 1) {
                    maskElement.setAttribute("stroke-miterlimit", data.ml)
                }
            }
            this.of = opFill
            this.ms = mask
            this.ost = stops
            this.maskId = maskId
        }
    }
}
