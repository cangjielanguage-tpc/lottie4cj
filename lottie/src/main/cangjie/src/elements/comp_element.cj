/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ICompElement.
 */
package lottie.elements

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
 * 1. buildAllItemsElement    => 传入 BaseRenderer 中的这个函数。
 * 2. checkLayers      => 传入 BaseRenderer 中的这个函数。
 */
public open class ICompElement <: BaseElement {
    //TODO：拆分多继承问题 -- extendPrototype([BaseElement, TransformElement, HierarchyElement, FrameElement, RenderableDOMElement], ICompElement)

    //TODO: 初始化后，传入 BaseRenderer.buildAllItemsElement() 函数。
    //public var buildAllItemsElement: (Array<Layer>) -> Unit = { m => ()}
    //TODO: 初始化后，传入 BaseRenderer.checkLayers(num: Float64) 函数。
    //public var checkLayers: (Float64) -> Unit = { m => ()}
    //public var createItem: (Layer) -> BaseElement = { m => return BaseElement(Layer(), GlobalData(), isNull: true) }


    //TODO: 数据类型未确认，暂定是 BaseElement
    //public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()

    //TODO: 未实现,初拟定了一个数据类型TM.
    public var tm: PropertyFactory<ContentModelDK, Float64> = unsafe {zeroValue<PropertyFactory<ContentModelDK, Float64>>()}
    //var renderedFrame: Float64 = 0.0


    //var completeLayers: Bool = false
    //public var layers: Array<Layer> = Array<Layer>()
    //TODO: 未确认数据类型，暂定为 BaseElement。
    //public var elements: Array<BaseElement> = Array<BaseElement>()

    /**
     * Create a ICompElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        //空初始化编译用
        //this.tm = PropertyFactory<ContentModelDK, Float64>(ContentModelDK(), 0.0, DynamicPropertyContainer(), GlobalData(), Layer(), types: 0, dynamicProperties: ArrayList<DynamicPropertyContainer>())
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
            var timeRemapped: Float64 = this.tm.v[0]
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
                let a = this.renderedFrame
                let b = this.layers[i].st
                let c = this.renderedFrame - this.layers[i].st
                this.elements[i].prepareFrame(this.renderedFrame - this.layers[i].st) // IShapeElement
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
    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {
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
    public open func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64) {
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
    public open func renderShapeColor(color: Array<Int64>, index: Int64) {
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



    //-------------------------------------------------------------------------------------
    /*
    public func buildAllItems(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            //在子类 CanvasRendererBase 中具体实现
            this.buildItem(i)
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }

    public func buildItem(pos: Int64): Unit {
        let elements: Array<BaseElement> = this.elements
        if ((elements.size > pos && !elements[pos].isNull) || this.layers[pos].ty == 99) {
        //if (this.elements.size > pos || this.layers[pos].ty == 99) {
            return
        }
        //TODO: 函数参数不一致，有 2 个参数暂时未传递。
        let element: BaseElement = this.createItem(this.layers[pos])
        //TODO: 【暂未处理】ArrayList 直接指定下标赋值报错。暂时改为append。 //this.elements.append(element)
        elements[pos] = element


        if (element.finalTransform.mProp.o.v.size > 0) {
        }


        element.initExpressions()
    }

    public func checkPendingElements(): Unit {
        while (this.pendingElements.size != 0) {
            let element: BaseElement = this.pendingElements.remove(this.pendingElements.size - 1)

            //TODO[lp]: - HierarchyElement.checkParenting => element 是 HierarchyElement ？？？
            element.checkParenting()
        }
    }

    public func checkLayers(num: Float64): Unit {
        var len: Int64 = this.layers.size
        var data: Layer = Layer()
        this.completeLayers = true

        for(i in ((len - 1)..=0 : -1)) {
            //如果当层无 element，代表该层 layer 未处理。
            //if (this.elements.size < i - 1) {
            if (this.elements[i].isNull) {
                data = this.layers[i]
                if ((data.ip - data.st) <= (num - this.layers[i].st) && (data.op - data.st) > (num - this.layers[i].st)) {
                    //在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                }
            }
            //this.completeLayers = this.elements[i] ? this.completeLayers : false
            if (this.elements[i].isNull) {
                this.completeLayers = false
            }
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }
    */


}
