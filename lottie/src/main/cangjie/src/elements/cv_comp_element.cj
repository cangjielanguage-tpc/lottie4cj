/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

public class CvCompElement <: ICompElement {

    protected var hasMasks: Bool = false

    //使用了data.layers暂时使用AnimationData
    public init(data: Layer, globalData: GlobalData, createItem: (Layer) -> BaseElement, buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit,
        compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>(),
        getElementByIdInRender!: (Int64) -> Option<BaseElement> = { m => Option<BaseElement>.None },
        compDataInd!: Int64 = -1
    ) {
        super(data, globalData)
        this.compType = compType
        this.compDataInd = compDataInd
        this.comp = comp
        this.getElementByIdInRender = getElementByIdInRender
        this.createItem = createItem
        this.buildElementParentingInComp = buildElementParentingInComp
        this.canvasContext = this.globalData.canvasContext
        this.completeLayers = false
        //使用了data.layers暂时使用AnimationData
        this.layers = data.layers

        this.elements = Array<BaseElement>(this.layers.size, item: BaseElement(Layer(), GlobalData(), isNull: true))

        //tm暂时不是data属性
        this.initElement(data, globalData)
        let dp = DynamicPropertyContainer(globalData, data, dynamicProperties: this.dynamicProperties)
        dp.dynamicProperties = this.dynamicProperties

        var renderedFrame: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>()
        if (compType == 1 && comp.size >= 1){
            renderedFrame = [comp[0].getRenderedFrameInElemComp]
        }

        var cdInd: Int64 = -1
        if (this.compType == 1 && this.compDataInd != -1) {
            cdInd = this.compDataInd
        } else if (this.compType == 1) {
            cdInd = this.data.ind
        }
        if (data.tm.k.size == 1) {
            this.tm = PropertyFactory<ContentModelDK, Float64>.getProp(data.tm, data.tm.k[0].k ?? 0.0, globalData.frameRate, dp, globalData, data, types: 0, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: renderedFrame, compDataInd: cdInd)
        } else if (data.tm.k.size > 1) {
            this.tm = PropertyFactory<ContentModelDK, Float64>.getProp(data.tm, data.tm.k, 0, globalData.frameRate, dp, globalData, data, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: renderedFrame, compDataInd: cdInd)
        } else {
            this.tm = PropertyFactory<ContentModelDK, Float64>(empty_ContentModelDK, 0.0, dp, globalData, data, types: 0, dynamicProperties: this.dynamicProperties, compDataInd: cdInd)
        }

        if(data.tm.k.size == 0) {
            this.tm._placeholder= true
        }

    }
    public func renderInnerContent() {
        var ctx = this.canvasContext

        ctx.beginPath()
        ctx.moveTo(0, 0)
        ctx.lineTo(this.data.w, 0.0)
        ctx.lineTo(this.data.w, this.data.h)
        ctx.lineTo(0.0, this.data.h)
        ctx.lineTo(0, 0)
        ctx.clip()

        let len: Int64 = this.layers.size
        for (i in (len - 1)..=0: -1) {
            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                this.elements[i].renderFrame()  //renderFrame
            }
        }
    }

    public override func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
        if (index == 0) {
            let len: Int64 = this.layers.size
            var i = len - 1
            while (i >= 0) {
                if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                    this.elements[i].changeColor(color, endColor)
                }
                i -= 1
            }
        } else {
            if (this.completeLayers || (this.elements.size > index - 1 && !this.elements[index - 1].isNull)) {
                this.elements[index - 1].changeColor(color, endColor)
            }
        }
    }

    public override func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64): Unit {
        if (endColor == 0) {
        var len = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                this.elements[i].changeColor(color, 0)
            }
        }
        } else {
            if (this.completeLayers || (this.elements.size > endColor-1 && !this.elements[endColor-1].isNull)) {
                this.elements[endColor-1].changeColor(color, 0)
            }
        }
    }

    public override func renderShapeColor(color: Array<Int64>, index: Int64): Unit {
        var len = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                this.elements[i].changeColor(color, 0)
            }
        }
    }


    public func destroy() {
        var len = this.layers.size
        var i = len - 1
        while (i >= 0) {
            if ((this.elements.size > i && !this.elements[i].isNull)) {
                this.elements[i].destroy()
            }
            i -= 1
        }
        this.layers = Array<Layer>()
        this.elements = Array<BaseElement>()
    }

    public func createComp(data: Layer) {
        return CvCompElement(data, this.globalData, this.createItem, this.buildElementParentingInComp)
    }

}
