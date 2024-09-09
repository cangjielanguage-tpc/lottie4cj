/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is HBaseElement.
 */
package lottie4cj.elements.html_elements

internal import std.collection.*
internal import lottie4cj.model.*
internal import lottie4cj.global_data.*
internal import lottie4cj.utils.helpers.*
internal import lottie4cj.*
internal import lottie4cj.elements.helpers.shapes.*
internal import lottie4cj.bezier.*
//TODO: 未完全实现
public open class HBaseElement <: Equatable<HBaseElement> {

    public var data: Datas
    public var globalData: GlobalData
    public var baseElement: CreateTag = CreateTag("")
    public var transformedElement: ?CreateTag = None
    public var svgElement: CreateNS = CreateNS("")
    public var layerElement: CreateNS = CreateNS("")
    public var maskedElement: CreateNS = CreateNS("")
    public var maskManager: ?MaskElement = None
    public var _isFirstFrame: Bool = false
    public var hidden: Bool = false
    public var finalTransform: FinalTransform = FinalTransform()

    public init(data: Datas, globalData: GlobalData) {
        this.globalData = globalData
        this.data = data
    }

    public func initRendererElement() {
        this.baseElement = CreateTag("div")
        if (this.data.hasMask) {
            this.svgElement = CreateNS("svg")
            this.layerElement = CreateNS("g")
            this.maskedElement = this.layerElement
            this.svgElement.appendChild(this.layerElement)
            this.baseElement.appendChild(this.svgElement)
       } else {
            this.layerElement = CreateNS("div")
        }
    }

    public func createContainerElements(){
        this.transformedElement = this.baseElement
        this.maskedElement = this.layerElement
        if (this.data.ln.size > 0) {
            this.layerElement.setAttribute('id', this.data.ln)
        }
        if (this.data.cl.size > 0) {
            this.layerElement.setAttribute('class', this.data.cl)
        }
        if (this.data.bm != 0) {
            this.setBlendMode()
        }
    }


    public func renderElement() {
        var transformedElementStyle = if (this.transformedElement.isSome()) {
            this.transformedElement.getOrThrow().style
        } else {
            TagStyle()
        }
        if (this.finalTransform._matMdf) {
            var matrixValue = this.finalTransform.mat.toCSS()
            transformedElementStyle.transform = matrixValue
            transformedElementStyle.webkitTransform = matrixValue
        }
        if (this.finalTransform._opMdf) {
            transformedElementStyle.opacity = this.finalTransform.mProp.o.v
        }
    }

    public func renderFrame() {
        // If it is exported as hidden (data.hd === true) no need to render
        // If it is not visible no need to render
        if (this.data.hd || this.hidden) {
            return
        }
        this.renderElement()
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }

    public func destroy() {
        
    }

    public func createRenderableComponents() {
        this.maskManager = MaskElement()
    }

    public func addEffects() {}
    public func setMatte() {}
    public func setBlendMode() {}

    public operator func ==(that: HBaseElement): Bool { return true }

    public operator func !=(that: HBaseElement): Bool { return !(this == that) }
}
