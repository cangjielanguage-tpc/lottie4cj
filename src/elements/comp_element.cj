/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ICompElement.
 */
package lottie4cj.elements

//TODO: 未实现，编译用
public class TM {
    var _placeholder: Bool = false
    var v: Float64 = 0.0
    public init() {}
    public init(_placeholder: Bool, v: Float64) {
        this._placeholder = _placeholder
        this.v = v
    }
}

/*
 * 初始化后需要传入1个函数：
 * 1. buildAllItems    => 传入 BaseRenderer 中的这个函数。
 * 2. checkLayers      => 传入 BaseRenderer 中的这个函数。
 */
public open class ICompElement <: BaseElement {
    //TODO：拆分多继承问题 -- extendPrototype([BaseElement, TransformElement, HierarchyElement, FrameElement, RenderableDOMElement], ICompElement)

    //TODO: 初始化后，传入 BaseRenderer.buildAllItems() 函数。
    public var buildAllItems: () -> Unit = { => ()}
    //TODO: 初始化后，传入 BaseRenderer.checkLayers(num: Float64) 函数。
    public var checkLayers: (Float64) -> Unit = { m => ()}

    public var supports3d: Bool = false
    //TODO: 未实现,初拟定了一个数据类型TM
    public var tm: TM = TM()
    var renderedFrame: Float64 = 0.0
    public var completeLayers: Bool = false
    public var layers: Array<Layer> = Array<Layer>()
    //TODO: 未确认数据类型，暂定为 BaseElement。
    public var elements: Array<BaseElement> = Array<BaseElement>()

    /**
     * Create a ICompElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func initElement(data: Layer, globalData: GlobalData) {
        this.initFrame()
        this.initBaseData(data, globalData)
        this.initTransform(data, globalData)
        this.initRenderable()
        this.initHierarchy()
        this.initRendererElement()
        this.createContainerElements()
        this.createRenderableComponents()
        if (this.data.xt || !globalData.progressiveLoad) {
            this.buildAllItems()
        }
        this.hide()
    }

    /**
     * Prepare frame.
     *
     * @param num - Type of Float64.
     */
    public func prepareFrame(num: Float64): Unit {
        this._mdf = false
        this.prepareRenderableFrame(num)
        this.prepareProperties(Int64(num), this.isInRange)
        //TODO: 未在 json 中找到 layers.xt，暂时定义为 Bool类型。
        if (!this.isInRange && !this.data.xt) {
            return
        }
    
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
            //TODO: 初始化后，传入 BaseRenderer.checkLayers(num: Float64) 函数。
            this.checkLayers(this.renderedFrame)
        }
        //由于表达式之间的连接方式，此迭代需要向后进行
        for (i in (len - 1)..=0:-1) {
            if (this.completeLayers || this.elements.size > i) {
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
    public open func renderInnerContent(): Unit {
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
    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
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
    public open func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64): Unit {
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
    public open func renderShapeColor(color: Array<Int64>, index: Int64): Unit {
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
    public open func destroy(): Unit {
        this.destroyElements()
        this.destroyBaseElement()
    }

}
