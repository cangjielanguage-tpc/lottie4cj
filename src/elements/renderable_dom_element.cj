/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is RenderableDOMElement.
 */
package lottie4cj.elements

internal import lottie4cj.utils.helpers.*

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
public open class RenderableDOMElement <: RenderableElement {
    //TODO：拆分多继承问题 -- extendPrototype([RenderableElement, createProxyFunction(_prototype)], RenderableDOMElement)

    //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
    public var baseElement: CreateNS = CreateNS("")
    public var layerElement: CreateNS = CreateNS("")
    //TODO：未确认来源和数据类型，暂定是 CreateNS。
    var innerElem: CreateNS = CreateNS("")

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    //TODO：编译用。后续子类实现。
    public open func renderElement(): Unit {}
    public open func destroyBaseElement(): Unit {}
    public open func initBaseData(data: Layer, globalData: GlobalData): Unit {}
    public open func initRendererElement(): Unit {}
    public open func createContainerElements(): Unit {}
    public open func createRenderableComponents(): Unit {}
    public open func createContent(): Unit {}

    public open func initElement(data: Layer, globalData: GlobalData) {
        //调用 FrameElement.initFrame
        this.initFrame()
        //调用 BaseElement.initBaseData
        this.initBaseData(data, globalData)
        //调用 TransformElement.initTransform
        this.initTransform(data, globalData)
        //调用 HierarchyElement.initHierarchy
        this.initHierarchy()
        //调用 RenderableElement.initRenderable
        this.initRenderable()
        //调用 CVBaseElement.initRendererElement
        this.initRendererElement()
        //调用 CVBaseElement.createContainerElements
        this.createContainerElements()
        //调用 CVBaseElement.createRenderableComponents
        this.createRenderableComponents()
        //调用 CVBaseElement.createContent
        this.createContent()
        this.hide()
    }

    public open func hide(): Unit {
        if (!this.hidden && (!this.isInRange || this.isTransparent)) {
            //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
            var elem: CreateNS = this.layerElement
            if (this.baseElement.isNull) {
                elem = this.baseElement
            }
            //TODO:还需要再确认一下elem数据类型，及elem.styles数据类型。 //elem.style.display = 'none'
            elem.styles.put("display", "none")
            this.hidden = true
        }
    }
    
    public open func show(): Unit {
        if (this.isInRange && !this.isTransparent) {
            if (!this.data.hd) {
                //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
                var elem: CreateNS = this.layerElement
                if (this.baseElement.isNull) {
                    elem = this.baseElement
                }
                //TODO:还需要再确认一下elem数据类型，及elem.styles数据类型。 //elem.style.display = 'block'
                elem.styles.put("display", "block")
            }
            this.hidden = false
            this._isFirstFrame = true
        }
    }
    
    public open func renderFrame(): Unit {
        //如果导出为隐藏（data.hd===true），则无需渲染
        //如果不可见，则无需渲染
        if (this.data.hd || this.hidden) {
            return
        }
        //调用 TransformElement.renderTransform
        this.renderTransform()
        
        //调用 RenderableElement.renderRenderable
        this.renderRenderable()
        
        //TODO: 未实现 HBaseElement.renderElement/SVGBaseElement.renderElement
        this.renderElement()
        
        this.renderInnerContent()
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }
    
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, index)
        this.isInRange = false
    }
    
    public open func renderInnerContent() {}
    
    public open func renderShapeColor(): Unit {}
    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {}
    
    public open func prepareFrame(num: Float64): Unit {
        this._mdf = false
        //调用 RenderableElement.prepareRenderableFrame
        this.prepareRenderableFrame(num)
        //调用 FrameElement.prepareProperties
        this.prepareProperties(Int64(num), this.isInRange)
        //调用 RenderableElement.checkTransparency
        this.checkTransparency()
    }
    
    public open func destroy(): Unit {
        //TODO：未确认来源和数据类型，暂定是 CreateNS。
        this.innerElem = CreateNS("")
        //TODO： 未确认调用哪块？ SVGBaseElement/HBaseElement
        this.destroyBaseElement()
    }

}
