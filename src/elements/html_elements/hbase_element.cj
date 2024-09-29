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
internal import lottie4cj.MaskElement
internal import lottie4cj.elements.helpers.shapes.*
internal import lottie4cj.bezier.*
internal import lottie4cj.utils.*
//TODO: 未完全实现
public open class HBaseElement <: BaseElement & Equatable<HBaseElement> {

    public var transformedElement: ?CreateTag = None
    public var svgElement: CreateNS = CreateNS("")

    var maskManager: ?MaskElement = None
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func initRendererElement() {
        // 未找到 this.data.tg
        this.baseElement = (CreateTag("div") as CreateNS).getOrThrow()
        if (this.data.hasMask) {
            this.svgElement = CreateNS("svg")
            this.layerElement = CreateNS("g")
            this.maskedElement = this.layerElement
            this.svgElement.appendChild(this.layerElement)
            this.baseElement.appendChild(this.svgElement)
        } else {
            this.layerElement = this.baseElement
        }
        styleDiv(this.baseElement)
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
            transformedElementStyle.opacity = Int64(this.finalTransform.mProp.o.v[0])
        }
    }

    public func renderFrame() {
        // If it is exported as hidden (data.hd === true) no need to render
        // If it is not visible no need to render
        if (this.data.hd || this.hidden) {
            return
        }
        // 调用不到 renderTransform() renderRenderable() renderInnerContent()
        this.renderElement()
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }

    public func destroy() {
        this.layerElement = CreateNS("")
        this.transformedElement = None
        if (this.matteElement.types.size > 0) {
            this.matteElement = CreateNS("")
        }
        if (this.maskManager.isSome()) {
            this.maskManager.getOrThrow().destroy()
            this.maskManager = None
        }
    }

    public func createRenderableComponents() {
        this.maskManager = MaskElement(this.data, this, this.globalData)
    }

    public func addEffects() {}
    public func setMatte() {}
    public func setBlendMode() {}

    public operator func ==(that: HBaseElement): Bool { return true }

    public operator func !=(that: HBaseElement): Bool { return !(this == that) }
}
