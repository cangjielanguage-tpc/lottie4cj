/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

//TODO
//public class CvCompElement <: ICompElement {
public class CvCompElement <: ICompElement {

    protected var hasMasks: Bool = false
    //protected var pendingElements: ArrayList<String>

    //使用了data.layers暂时使用AnimationData
    public init(data: Layer, globalData: GlobalData, createItem: (Layer) -> BaseElement, buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit) {
        super(data, globalData)
        this.createItem = createItem
        this.buildElementParentingInComp = buildElementParentingInComp
        this.canvasContext = this.globalData.canvasContext
        this.completeLayers = false
        //使用了data.layers暂时使用AnimationData
        this.layers = data.layers
        //this.layers = Array<Layer>()
        //this.pendingElements = ArrayList<String>()
        this.elements = Array<BaseElement>(this.layers.size, item: BaseElement(Layer(), GlobalData(), isNull: true))

        //this.buildAllItemsElement = globalData.buildAllItemsElement
        //this.checkLayers = globalData.checkLayers
        //this.createItem = globalData.createItem

        //tm暂时不是data属性
        this.initElement(data, globalData)
        let dp = DynamicPropertyContainer(globalData, data, dynamicProperties: this.dynamicProperties)
        dp.dynamicProperties = this.dynamicProperties

        if (data.tm.k.size == 1) {
            this.tm = PropertyFactory<ContentModelDK, Int64>.getProp(data.tm, data.tm.k[0].k ?? 0.0, globalData.frameRate, dp, globalData, data, types: 0, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1)
        } else if (data.tm.k.size > 1) {
            this.tm = PropertyFactory<ContentModelDK, Int64>.getProp(data.tm, data.tm.k, 0, globalData.frameRate, dp, globalData, data, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1)
        }
        this.tm.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

        
        if(data.tm.k.size == 0) {
            this.tm._placeholder= true
        }

    }
    public func renderInnerContent() {
        //this.canvasContext.fillStyle(Color.RED)
        //this.canvasContext.fillRect(0, 30, 100, 100)

        var ctx = this.canvasContext

        ctx.beginPath()
        ctx.moveTo(0, 0)
        ctx.lineTo(this.data.w, 0.0)  //1920
        ctx.lineTo(this.data.w, this.data.h)////1920  1080
        ctx.lineTo(0.0, this.data.h)//1080

//        ctx.lineTo(20, 0)
//        ctx.lineTo(90, 20)
//        ctx.lineTo(0, 100)

        ctx.lineTo(0, 0)
        ctx.clip()

        //TODO:用于测试
//        ctx.closePath()
//        ctx.stroke()
                    //this.canvasContext.beginPath()
                    //this.canvasContext.moveTo(30, 30)
                    //this.canvasContext.lineTo(300, 30)
                    //this.canvasContext.lineTo(70, 90)
                    //this.canvasContext.clip()
                    //this.canvasContext.closePath()
                    //this.canvasContext.stroke()

        var indexCOMP: Int64 = 3
        this.elements[indexCOMP].renderFrame()
        //let len: Int64 = this.layers.size
        //var indexCOMP: Int64 = 0
        //for (i in (len - 1)..=0: -1) {
        //    indexCOMP = i
        //    if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
        //        this.elements[i].renderFrame()  //renderFrame
        //    }
        //}
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
                //this.elements[i].changeColor(color, undefined)
                this.elements[i].changeColor(color, 0)
            }
        }
        } else {
            if (this.completeLayers || (this.elements.size > endColor-1 && !this.elements[endColor-1].isNull)) {
                //this.elements[endColor-1].changeColor(color, undefined)
                this.elements[endColor-1].changeColor(color, 0)
            }
        }
    }

    public override func renderShapeColor(color: Array<Int64>, index: Int64): Unit {
        var len = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                //this.elements[i].changeColor(color, undefined)
                this.elements[i].changeColor(color, 0)
            }
        }
    }


    public func destroy() {
        var len = this.layers.size
        var i = len - 1
        while (i >= 0) {
            if ((this.elements.size > i && !this.elements[i].isNull)) {
                this.elements[i].destroy()  ///CvShapeElement
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
