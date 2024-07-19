/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements.svg_elements

internal import std.collection.*
internal import lottie4cj.utils.*
internal import lottie4cj.model.*
internal import lottie4cj.global_data.*
internal import lottie4cj.utils.helpers.*
internal import lottie4cj.elements.*

//TODO: 未完全实现
public open class SvgBaseElement <: Equatable<SvgBaseElement> {

    public var data: Layer

    public var matteMasks: HashMap<Int64,String> = HashMap<Int64,String>()

    var layerId: String = ""

    public var globalData: GlobalData

    var matteElement: CreateNS = CreateNS("")
    var baseElement: CreateNS = CreateNS("")

    var transformedElement: CreateNS = CreateNS("")

    var layerElement: CreateNS = CreateNS("")

    var maskedElement: CreateNS = CreateNS("")

    var _sizeChanged: Bool = false

    public init(data: Layer, globalData: GlobalData) {
        this.globalData = globalData
        this.data = data
    }

    public func initRendererElement() {
        this.layerElement = CreateNS("g")
    }

    public func createContainerElements() {
        this.matteElement = CreateNS("g")
        this.transformedElement = this.layerElement
        this.maskedElement = this.layerElement
        this._sizeChanged = false;
        var layerElementParent: Option<CreateNS> = None

        if (this.data.td != 0) {
            this.matteMasks = HashMap<Int64,String>()
            var gg = CreateNS("g")
            gg.setAttribute("id", this.layerId)
            gg.appendChild(this.layerElement)
            layerElementParent = gg
            this.globalData.defs.appendChild(gg)
        } else if (this.data.tt != 0) {
            this.matteElement.appendChild(this.layerElement)
            layerElementParent = this.matteElement
            this.baseElement = this.matteElement
        } else {
            this.baseElement = this.layerElement
        }

        // if (this.data.ln) {
        //     this.layerElement.setAttribute("id", this.data.ln)
        // }
        if (!this.data.cl.isEmpty()) {
            this.layerElement.setAttribute("class", this.data.cl)
        }
        if (this.data.ty == 0 && !this.data.hd) {
            var cp = CreateNS("clipPath")
            var pt = CreateNS("path")
            pt.setAttribute("d", "M0,0 L" + "${this.data.w}" + ",0 L" + "${this.data.w}" + "," + "${this.data.h}" + " L0," + "${this.data.h}" + "z")
            var clipId = CreateElementID.createID()
            cp.setAttribute("id", clipId)
            cp.appendChild(pt)
            this.globalData.defs.appendChild(cp)

            //TODO
            //if (this.checkMasks()) {
            if (this._sizeChanged) {
                var cpGroup = CreateNS("g")
                cpGroup.setAttribute("clip-path", "url(" + getLocationHref() + "#" + clipId + ")")
                cpGroup.appendChild(this.layerElement)
                this.transformedElement = cpGroup
                if (layerElementParent.isSome()) {
                    layerElementParent.getOrThrow().appendChild(this.transformedElement)
                } else {
                    this.baseElement = this.transformedElement
                }
            } else {
                this.layerElement.setAttribute("clip-path", "url(" + getLocationHref() + "#" + clipId + ")")
            }
        }
        if (this.data.bm != 0) {
            //this.setBlendMode()
        }
    }

    public func renderElement() {
        //TODO
    }

    public func destroyBaseElement() {
        this.layerElement = CreateNS("")
        // this.layerElement = None
        // this.matteElement = None
        this.matteElement = CreateNS("")
        //this.maskManager.destroy()
    }

    public func getBaseElement(): Option<CreateNS> {
        if (this.data.hd) {
            return None
        }
        return this.baseElement
    }

    public func createRenderableComponents() {
        //TODO
    }

    public func getMatte(matteType: Int64) {
        if (this.matteMasks.isEmpty()) {
            this.matteMasks = HashMap<Int64,String>()
        }

        if (!this.matteMasks.contains(matteType)) {
            var id = this.layerId + "_" + "${matteType}"
            var filId: String
            var fil: CreateNS
            var useElement: CreateNS
            var gg: CreateNS
            if (matteType == 1 || matteType == 3) {
                var masker = CreateNS("mask")
                masker.setAttribute("id", id)
                if (matteType == 3) {
                    masker.setAttribute("mask-type","luminance")
                }else {
                    masker.setAttribute("mask-type","alpha")
                }
                useElement = CreateNS("use")
                useElement.setAttributeNS("http://www.w3.org/1999/xlink", "href", "#" + this.layerId)
                masker.appendChild(useElement)
                this.globalData.defs.appendChild(masker)
                if (!FeatureSupport.maskType && matteType == 1) {
                    masker.setAttribute("mask-type", "luminance")
                    filId = CreateElementID.createID()
                    fil = FiltersFactory.createFilter(filId)
                    this.globalData.defs.appendChild(fil)
                    fil.appendChild(FiltersFactory.createAlphaToLuminanceFilter())
                    gg = CreateNS("g")
                    gg.appendChild(useElement)
                    masker.appendChild(gg)
                    gg.setAttribute("filter", "url(" + getLocationHref() + "#" + filId + ")")
                }
            } else if (matteType == 2) {
                var maskGroup = CreateNS("mask")
                maskGroup.setAttribute("id", id)
                maskGroup.setAttribute("mask-type", "alpha")
                var maskGrouper = CreateNS("g")
                maskGroup.appendChild(maskGrouper)
                filId = CreateElementID.createID()
                fil = FiltersFactory.createFilter(filId)
                /// /
                var feCTr = CreateNS("feComponentTransfer")
                feCTr.setAttribute("in", "SourceGraphic")
                fil.appendChild(feCTr)
                var feFunc = CreateNS("feFuncA")
                feFunc.setAttribute("type", "table")
                feFunc.setAttribute("tableValues", "1.0 0.0")
                feCTr.appendChild(feFunc)
                /// /
                this.globalData.defs.appendChild(fil)
                var alphaRect = CreateNS("rect")
                // alphaRect.setAttribute("width", this.comp.data.w)
                // alphaRect.setAttribute("height", this.comp.data.h)
                alphaRect.setAttribute("x", "0")
                alphaRect.setAttribute("y", "0")
                alphaRect.setAttribute("fill", "#ffffff")
                alphaRect.setAttribute("opacity", "0")
                maskGrouper.setAttribute("filter", "url(" + getLocationHref() + "#" + filId + ")");
                maskGrouper.appendChild(alphaRect)
                useElement = CreateNS("use")
                useElement.setAttributeNS("http://www.w3.org/1999/xlink", "href", "#" + this.layerId)
                maskGrouper.appendChild(useElement)
                if (!FeatureSupport.maskType) {
                    maskGroup.setAttribute("mask-type", "luminance")
                    fil.appendChild(FiltersFactory.createAlphaToLuminanceFilter())
                    gg = CreateNS("g")
                    maskGrouper.appendChild(alphaRect)
                    gg.appendChild(this.layerElement)
                    maskGrouper.appendChild(gg)
                }
                this.globalData.defs.appendChild(maskGroup)
            }
            this.matteMasks[matteType] = id
        }
        return this.matteMasks[matteType]
    }

    public func setMatte(id: String) {
        // if (!this.matteElement) {
        //     return
        // }
        this.matteElement.setAttribute("mask", "url(" + getLocationHref() + "#" + id + ")")
    }
    

    public operator func ==(that: SvgBaseElement): Bool { return true }

    public operator func !=(that: SvgBaseElement): Bool { return !(this == that) }

}

var locationHref = ""
public func getLocationHref(){
    return locationHref
}
public func setLocationHref(value: String) {
    locationHref = value
}