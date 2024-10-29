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
    public init(data: Layer, globalData: GlobalData, createItem: (Layer) -> BaseElement, buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit,
        compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>()
    ) {
        super(data, globalData)
        this.compType = compType
        this.comp = comp
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
        
        //空初始化编译用
        //this.tm = PropertyFactory<ContentModelDK, Float64>(ContentModelDK(), 0.0, DynamicPropertyContainer(), GlobalData(), Layer(), types: 0, dynamicProperties: ArrayList<DynamicPropertyContainer>())

        //tm暂时不是data属性
        this.initElement(data, globalData)
        let dp = DynamicPropertyContainer(globalData, data, dynamicProperties: this.dynamicProperties)
        dp.dynamicProperties = this.dynamicProperties

        var renderedFrame: Array<() -> Float64> = Array<() -> Float64>()
        if (compType == 1 && comp.size >= 1){
            renderedFrame = [comp[0].getRenderedFrameInElemComp]
        }

        if (data.tm.k.size == 1) {
            this.tm = PropertyFactory<ContentModelDK, Float64>.getProp(data.tm, data.tm.k[0].k ?? 0.0, globalData.frameRate, dp, globalData, data, types: 0, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: renderedFrame)
        } else if (data.tm.k.size > 1) {
            this.tm = PropertyFactory<ContentModelDK, Float64>.getProp(data.tm, data.tm.k, 0, globalData.frameRate, dp, globalData, data, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: renderedFrame)
        }
        //this.tm.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

        
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

        //var indexCOMP: Int64 = 29
        //if (this.completeLayers || (this.elements.size > indexCOMP && !this.elements[indexCOMP].isNull)) {
        //    this.elements[indexCOMP].renderFrame()
        //}
//        this.elements[0].renderFrame()
//        this.elements[1].renderFrame()
//        this.elements[2].renderFrame()
//        this.elements[3].renderFrame()
//        this.elements[4].renderFrame()// Nothing
//        this.elements[5].renderFrame()
//        this.elements[6].renderFrame() // 没有显示
//        this.elements[7].renderFrame()
//        this.elements[8].renderFrame()
//        this.elements[9].renderFrame()
//        this.elements[10].renderFrame()
//        this.elements[11].renderFrame()// Nothing
//        this.elements[12].renderFrame()// Nothing
//        this.elements[13].renderFrame()
//        this.elements[14].renderFrame() // Nothing
//        this.elements[15].renderFrame()// Nothing
//        this.elements[16].renderFrame()
//        this.elements[17].renderFrame()
        let len: Int64 = this.layers.size
        var indexCOMP: Int64 = 0
        for (i in (len - 1)..=0: -1) {
            indexCOMP = i
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
