/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.html_elements

internal import lottie4cj.elements.svg_elements.*
//TODO
public class HCompElement <: ICompElement {

    public var svgElement: CreateNS = CreateNS("")
    public var transformedElement: ?CreateNS = None

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.layers = this.data.layers
        this.supports3d = !data.hasMask
        this.completeLayers = false
        this.elements = if (this.layers.size > 0) {
            Array<BaseElement>(this.layers.size, repeat: BaseElement(data, globalData))
        }else {
            Array<BaseElement>()
        }
    }

    public func createContainerElements() {
        if (this.data.hasMask) {
            this.svgElement.setAttribute("width", "${this.data.w}")
            this.svgElement.setAttribute("height", "${this.data.h}")
            this.transformedElement = this.maskedElement
        } else {
            this.transformedElement = this.layerElement
        }
    }

    public func addTo3dContainer(elem: CreateNS, pos: Int64) {
        var j = 0
        var nextElement: ?CreateNS = None
        while (j < pos) {
            if (this.elements.size > j) {
                nextElement = (this.elements[j].layerElement as CreateNS).getOrThrow()
            }
            j += 1
        }
        if (nextElement.isSome()) {
            this.layerElement.insertBefore(elem, nextElement.getOrThrow())
        } else {
            this.layerElement.appendChild(elem)
        }
    }

    public func createComp(data: Layer) {
        if (!this.supports3d) {
            return SVGCompElement(data, this.globalData)
        }
        return HCompElement(data, this.globalData)
    }
}