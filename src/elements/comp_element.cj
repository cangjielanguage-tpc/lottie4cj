/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ICompElement.
 */
package lottie4cj.elements

//TODO: 未实现，编译用
class TM {
    var _placeholder: Bool = false
    var v: Float64 = 0.0
}

public class ICompElement <: BaseElement {

    //TODO：拆分多继承问题 -- extendPrototype([BaseElement, TransformElement, HierarchyElement, FrameElement, RenderableDOMElement], ICompElement)

    //TODO: 未实现,初拟定了一个数据类型TM
    var tm: TM = TM()
    var renderedFrame: Float64 = 0.0
    var completeLayers: Bool = false
    public var layers: Array<Layer> = Array<Layer>()
    //TODO: 未确认数据类型
    public var elements: Array<BaseElement> = Array<BaseElement>()

    //TODO: 未完全实现 RendererBase/CanvasRendererBase  //var comp: RendererBase

    /**
     * Create a ICompElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    //TODO: 未完全实现 BaseRenderer
    //TODO: 未实现 initElement
    
    /**
     * Prepare frame.
     *
     * @param num - Type of Float64.
     */
    public func prepareFrame(num: Float64): Unit {
        this._mdf = false
        //TODO: (问题点)仓颉的calss是单继承，调不到 RenderableElement.prepareRenderableFrame  //this.prepareRenderableFrame(num)
        //TODO: (问题点)仓颉的calss是单继承，调不到 FrameElement.prepareProperties   //this.prepareProperties(num, this.isInRange)
        //TODO: 未找到 data.xt    //if (!this.isInRange && !this.data.xt) { return }
    
        if (!this.tm._placeholder) {
            var timeRemapped: Float64 = this.tm.v
            if (timeRemapped == this.data.op) {
                timeRemapped = this.data.op - 1.0
            }
            this.renderedFrame = timeRemapped
        } else {
            this.renderedFrame = num / this.data.sr
        }

        let len: Int64 = this.elements.size
        if (!this.completeLayers) {
            //TODO: (问题点)仓颉的calss是单继承，调不到 BaseRenderer.checkLayers   //this.checkLayers(this.renderedFrame)
        }
        //由于表达式之间的连接方式，此迭代需要向后进行
        for (i in (len - 1)..=0:-1) {
            if (this.completeLayers || this.elements.size > i) {
                //TODO: 未实现 elements[i].prepareFrame
                this.elements[i].prepareFrame(this.renderedFrame - this.layers[i].st)
                if (this.elements[i]._mdf) {
                    this._mdf = true
                }
            }
        }
    }
    
    /**
     * Render inner content.
     */
    public func renderInnerContent(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                this.elements[i].renderFrame()
            }
        }
    }
    
    /**
     * Render shape color.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param endColor - Type of Array<Int64>, End color array RGBA.
     * @param index - Type of Int64, the subscript value of elements in the corresponding hierarchy.
     */
    public func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
        if (index == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color, endColor)
                }
            }
        } else {
            if (this.completeLayers || this.elements.size > (index - 1)) {
                this.elements[index-1].changeColor(color, endColor)
            }
        }
    }

    /**
     * Render shape color.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param endColor - Type of Int64, Index value of hierarchy.
     * @param index - Type of Int64, the subscript value of elements in the corresponding hierarchy.
     */
    public func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64) {
        if (endColor == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color)
                }
            }
        } else {
            if (this.completeLayers || this.elements.size > (endColor - 1)) {
                this.elements[endColor-1].changeColor(color)
            }
        }
    }

    /**
     * Render shape color.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param index - Type of Int64, the subscript value of elements in the corresponding hierarchy.
     */
    public func renderShapeColor(color: Array<Int64>, index: Int64) {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                this.elements[i].changeColor(color)
            }
        }
    }

    /**
     * Set elements value.
     *
     * @param color - Type of Array<BaseElement>.
     */
    public func setElements(elems: Array<BaseElement>): Unit {
        this.elements = elems
    }
    
    /**
     * Return the elements value.
     *
     * @return Type of Array<BaseElement>, the elements value.
     */
    public func getElements(): Array<BaseElement> {
        return this.elements
    }

    /**
     * Destroy the Element.
     */
    public func destroyElements(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            if (this.elements.size > i) {
                this.elements[i].destroy()
            }
        }
    }

    /**
     * Destroy the ICompElement.
     */
    public func destroy(): Unit {
        this.destroyElements()
        //TODO: 未实现  //this.destroyBaseElement()
    }

}
