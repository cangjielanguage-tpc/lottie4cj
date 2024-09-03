/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

import lottie4cj.utils.helpers.*
import lottie4cj.utils.helpers.*
//TODO 未完全实现
public class CVShapeElement <: IShapeElement {

    protected var stylesList: ArrayList<StyleElem>
    protected var prevViewData: ArrayList<Object>
    protected var transformsManager: ShapeTransformManager

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.shapes = Array<CVShapeData>()
        this.shapesData = data.shapes
        this.stylesList = ArrayList<StyleElem>()
        this.itemsData = Array<ContentModel>()
        this.prevViewData = ArrayList<Object>()
        this.shapeModifiers = Array<ShapeModifiers>()
        this.processedElements = ArrayList<ProcessedElement>()
        this.transformsManager = ShapeTransformManager()
    }

    public func initElement() {
        //RenderableDOMElement.initElement
    }

    public func transformHelper(): TransformHelpers {
        return TransformHelpers(1, false)
    }

    public func dashResetter() {
        Array<Float64>()
    }

    public func createContent() {
        //this.searchShapes(this.shapesData, this.itemsData, this.prevViewData, true, ArrayList<Object>())
    }

    public func createStyleElement(data: Data, transforms: ArrayList<Object>) {
        //TODO
    }

    public func createGroupElement() {
        //TODO
    }

    public func createTransformElement(data: Data) {
        //TODO
    }

    public func createShapeElement(data: ShapeDataInCV) {
        var elementData = CVShapeData()
        this.shapes.set(this.shapes.size,elementData)
        return elementData
    }

    public func reloadShapes() {
        var len = this.itemsData.size
        for (i in 0..len) {
            this.prevViewData[i] = this.itemsData[i]
        }
        this.transformsManager.processSequences(this._isFirstFrame)
    }

    public func addTransformToStyleList(transform: Object) {

        var len = this.stylesList.size
        for (i in 0..len) {
            if (!this.stylesList[i].closed) {
                this.stylesList[i].transforms.append(transform)
            }
        }
    }

    public func removeTransformFromStyleList() {
        var len = this.stylesList.size
        for (i in 0..len) {
            if (!this.stylesList[i].closed) {
                this.stylesList[i].transforms.remove(this.stylesList[i].transforms.size - 1)
            }
        }
    }

    public func closeStyles(styles: ArrayList<StyleElem>) {
        var len = styles.size
        for (i in 0..len) {
            styles[i].closed = true
        }
    }

    public func searchShapes() {
        
    }

    public func renderInnerContent() {
        this.transformHelper().opacity = 1
        this.transformHelper()._opMdf = false
        this.renderModifiers()
        this.transformsManager.processSequences(this._isFirstFrame)
        //this.renderShape(this.transformHelper(), this.shapesData, this.itemsData, true)
    }

    public func renderShapeTransform(parentTransform: TransformHelpers,groupTransform: Object) {
        //TODoo
    }

    public func drawLayer() {
        var len = this.stylesList.size
        var ctx = this.globalData.canvasContext
        var types: String
        var currentStyle: StyleElem
        for (i in 0..len) {
            currentStyle = this.stylesList[i]
            types = currentStyle.types

            // Skipping style when
            // Stroke width equals 0
            // style should not be rendered (extra unused repeaters)
            // current opacity equals 0
            // global opacity equals 0
            if (!(((types == "st" || types == "gs") && currentStyle.wi == 0) || !currentStyle.data._shouldRender || currentStyle.coOp == 0 || this.globalData.currentGlobalAlpha == 0)) {
                var elems = currentStyle.elements
                //renderer.ctxOpacity(currentStyle.coOp)
                if (types != "st" && types != "gs") {
                    ctx.beginPath()
                }
                //renderer.ctxTransform(currentStyle.preTransforms.finalTransform.props)
                var jLen = elems.size
                for (j in 0..jLen) {
                    if (types == "st" || types == "gs") {
                        if (!currentStyle.da.isEmpty()) {
                            //ctx.setLineDash()无法自动将currentStyle.da拆分为两个参数，导致传入接口参数个数不正确，所以这里需要手动拆分
                            //判断currentStyle.da数组长度是否大于等于2，如果是则把数组的值取出来，传给ctx.setLineDash()方法
                            if (currentStyle.da.size >= 2) {
                                var s1 = currentStyle.da[0]
                                var s2 = currentStyle.da[1]
                            } else {
                                var s1 = currentStyle.da[0]
                            }
                            //ctx.lineDashOffset = currentStyle.do
                        }
                    }
                    if (types == "st" || types == "gs") {
                        ctx.restoreLayer()

                    }
                }
                if (types != "st" && types != "gs") {
                    ctx.fill(currentStyle.r)
                }
            }
        }
    }

    public func renderShapeColor(color: Array<Int64>,endColor: Array<Int64>,itemes: ?Array<ContentModel>, datas: Array<ContentModel>) {
        var items: Array<ContentModel>
        var data: Array<ContentModel>
        if (itemes.isNone() || itemes.getOrThrow().size == 0) {
            items = this.shapesData
            data = this.itemsData
        }else {
            items = itemes.getOrThrow()
            data  = datas
        }
        var len = items.size - 1
        var i = len
        //TODO
    }

    public func renderShape(parentTransform: TransformHelpers, items: Array<ShapeDataInCV>, data: Array<ItemData>, isMain!: Bool = false): Unit {
        var len = items.size - 1
        var groupTransform = parentTransform
        var i = len
        while (i >= 0) {
            if (items[i].ty == "tr") {
                groupTransform = data[i].transform
                this.renderShapeTransform(parentTransform, groupTransform)
            } else if (items[i].ty == "sh" || items[i].ty == "el" || items[i].ty == "rc" || items[i].ty == "sr") {
                this.renderPath(items[i], data[i])
            } else if (items[i].ty == "fl") {
                this.renderFill(items[i], data[i], groupTransform)
            } else if (items[i].ty == "st") {
                this.renderStroke(items[i], data[i], groupTransform)
            } else if (items[i].ty == "gf" || items[i].ty == "gs") {
                this.renderGradientFill(items[i], data[i], groupTransform)
            } else if (items[i].ty == "gr") {
                this.renderShape(groupTransform, items[i].it, data[i].it)
            } else if (items[i].ty == "tm") {
            //
            }
            i -= 1
        }
        if (isMain) {
            this.drawLayer()
        }
    }

    public func renderStyledShape(styledShape: Object, shape: Object) {
        //TODO
    }

    public func renderPath(pathData: ShapeDataInCV, itemData: Object) {
        //TODO
    }

    public func renderFill(styleData: Object, itemData: ItemData, groupTransform: TransformHelpers) {
        var styleElem = itemData.style
        if (itemData.c._mdf || this._isFirstFrame) {
            styleElem.co = "rgb("
                + "${floor(itemData.c.v[0])}" + ","
                + "${floor(itemData.c.v[1])}" + ","
                + "${floor(itemData.c.v[2])}" + ")"
        }
        if (itemData.o._mdf || groupTransform._opMdf || this._isFirstFrame) {
            styleElem.coOp = itemData.o.v * groupTransform.opacity
        }
    }

    public func renderGradientFill(styleData: Object, itemData: Object, groupTransform: TransformHelpers) {
        //TODO
    }

    public func renderStroke(styleData: Object, itemData: Object, groupTransform: TransformHelpers) {
        //TODO  
    }

    public func destroy() {
        //TODO  
    }
}

public class CVShapeDatas {
    public var ty: String = ""

    public var fillEnabled: Bool = false

    public var c: ArrayList<Object> = ArrayList<Object>()

    public var w: ArrayList<Object> = ArrayList<Object>()

    public var o: ArrayList<Object> = ArrayList<Object>()

    public var lc: Int64 = 0

    public var lj: Int64 = 0

    public var ml: Int64 = 0

    public var nm: String = ""

    public var _shouldRender: Bool = false

}

public class TransformHelpers {
    protected var opacity: Int64
    protected var _opMdf: Bool

    public init(opacity: Int64, _opMdf: Bool) {
        this.opacity = opacity
        this._opMdf = _opMdf
    }
}

public class StyleElem {
    protected var data: CVShapeDatas
    protected var types: String
    protected var preTransforms: Object
    protected var transforms: ArrayList<Object>
    protected var elements: ArrayList<Object>
    protected var closed: Bool
    protected var co: String = ""
    protected var fl: String = ""
    protected var wi: Int64 = 0
    protected var coOp: Int64 = 0
    protected var r: Int64 = 0
    protected var da: ArrayList<Object> = ArrayList<Object>()

    public init(data: CVShapeDatas, types: String, preTransforms: Object, transforms: ArrayList<Object>,
        elements: ArrayList<Object>, closed: Bool) {
        this.data = data
        this.types = types
        this.preTransforms = preTransforms
        this.transforms = transforms
        this.elements = elements
        this.closed = closed
    }
}

public class ItemData {
    var c: ItemDatac = ItemDatac()
    var o: ItemDatao = ItemDatao()
    var transform: TransformHelpers
    var style: StyleElem 
    var it: Array<ItemData> = Array<ItemData>() 
    init(style: StyleElem  , transform: TransformHelpers) {
        this.style = style  
        this.transform = transform
    }
}
class ItemDatac {
    var v: Array<Float64> = Array<Float64>()
    var _mdf: Bool = false
}
class ItemDatao {
    var _mdf: Bool = false
    var v: Int64 = 0
}



