/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

import lottie.utils.helpers.*
import lottie.utils.helpers.*
internal import lottie.property.*
internal import lottie.pool.*

internal import ohos.component.CanvasGradient

//TODO 未完全实现
public class CvShapeElement <: IShapeElement {
//public class CvShapeElement <: CvBaseElement {

    protected var stylesList: ArrayList<StyleElem>
    protected var prevViewData: Array<ContentModelElement>
    protected var itemsData: Array<ContentModelElement>
    protected var transformsManager: ShapeTransformManager

    let dp: DynamicPropertyContainer

    public init(data: Layer, globalData: GlobalData, buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit,
        //pendingElements: ArrayList<BaseElement>,
        layers!: Array<Layer> = Array<Layer>(), elements!: Array<BaseElement> = Array<BaseElement>(),
        compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>(),
        getElementByIdInRender!: (Int64) -> Option<BaseElement> = { m => Option<BaseElement>.None }
    ) {
        super(data, globalData)
        this.compType = compType
        this.comp = comp
        this.getElementByIdInRender = getElementByIdInRender
        //this.pendingElements = pendingElements
        this.layers = layers
        this.elements = elements
        this.buildElementParentingInComp = buildElementParentingInComp
        this.dp = DynamicPropertyContainer(globalData, data, dynamicProperties: this.dynamicProperties)
        this.shapes = ArrayList<CvShapeData>()
        this.shapesData = data.shapes   //原生的 Layer.shapes
        this.stylesList = ArrayList<StyleElem>()
        this.itemsData = Array<ContentModelElement>(this.shapesData.size, item: empty_ContentModelElement)  //储存的是处理后的 Layer.shapes
        this.prevViewData = Array<ContentModelElement>(this.shapesData.size, item: empty_ContentModelElement)
        this.shapeModifiers = ArrayList<ShapeModifier>()
        this.processedElements = ArrayList<ProcessedElement>()
        this.transformsManager = ShapeTransformManager()
        this.initElement(data, globalData)
    }

//    public func initElement() {
//        //RenderableDOMElement.initElement
//    }

    //初始化一个空的 TransformInElement。
    public let transformHelper: TransformInElement = TransformInElement(opacity: 1.0, _opMdf: false, op: empty_pf_ArrayKeyframeInt64_Int64, mProps: empty_tp)
    //public func transformHelper(): TransformInElement {
    //    return TransformInElement(opacity: 1.0, _opMdf: false,
    //        op: PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, dp, GlobalData(), Layer(), dynamicProperties: this.dynamicProperties),
    //        mProps: TransformProperty(isNull: true, dynamicProperties: this.dynamicProperties)
    //    )
    //}

    public func dashResetter() {
        Array<Float64>()
    }

    public override func renderFrame(): Unit {
        super.renderFrame(false)
    }

    public func createContent() {
        this.searchShapes(this.shapesData, this.itemsData, this.prevViewData, true, ArrayList<AnimatableTransformElement>())
    }

    public func createStyleElement(cm: ContentModel, transforms: ArrayList<AnimatableTransformElement>): FillStrokeElement {
        if(!(cm.ty == "fl" || cm.ty == "st" || cm.ty == "gf" || cm.ty == "gs")){
            throw Exception("data.ty != fl/st/gf/gs")
        }
        let data: FillStroke = (cm as FillStroke).getOrThrow()
        let styleElem = StyleElem(data: data,
            types: data.ty,
            preTransforms: this.transformsManager.addTransformSequence(transforms),
            //transforms: ArrayList<ContentModelElement>(),
            //elements: ArrayList<StyledShape>(),
            closed: data.hd == true
        )
        var elementData = FillStrokeElement(isNull: true, dynamicProperties: this.dynamicProperties)
        //let dp: DynamicPropertyContainer = DynamicPropertyContainer(this.globalData, this.data)
        var vLen: Int64 = 2
        if (data.ty == "fl" || data.ty == "st") {

            if (data.c.size == 1) {
                elementData.c = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.c, data.c[0].k ?? Array<Float64>(), 255.0, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else if (data.c.size > 1) {
                if (data.c.size > 0) { vLen = (data.c[0].s ?? Array<Float64>()).size }
                elementData.c = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.c, data.c, 1, 255.0, dp, this.globalData, this.data, vLen: vLen, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            }
            elementData.c.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

        
            if (!elementData.c.k) {
                //styleElem.co = "rgb(" + "${floor(elementData.c.v[0])}" + "," + "${floor(elementData.c.v[1])}" + "," + "${floor(elementData.c.v[2])}" + ")"
                styleElem.co = Color(UInt8(floor(elementData.c.v[0])), UInt8(floor(elementData.c.v[1])), UInt8(floor(elementData.c.v[2])))
            }
        } else if (data.ty == "gf" || data.ty == "gs") {

            if (data.s.size == 1) {
                elementData.s = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.s, data.s[0].k ?? Array<Float64>(), 0.0, dp, this.globalData, this.data, types: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else if (data.s.size > 1) {
                if (data.s.size > 0) { vLen = (data.s[0].s ?? Array<Float64>()).size }
                elementData.s = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.s, data.s, 1, 0.0, dp, this.globalData, this.data, vLen: vLen, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            }
            elementData.s.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
            if (data.e.size == 1) {
                elementData.e = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.e, data.e[0].k ?? Array<Float64>(), 0.0, dp, this.globalData, this.data, types: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else if (data.e.size > 1) {
                if (data.e.size > 0) { vLen = (data.e[0].s ?? Array<Float64>()).size }
                elementData.e = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(data.e, data.e, 1, 0.0, dp, this.globalData, this.data, vLen: vLen, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            }
            elementData.e.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
            //TODO: h 成员变量暂时是空的。
            // elementData.h = PropertyFactory.getProp(this, data.h || { k: 0 }, 0, 0.01, this)
            elementData.a = PropertyFactory<AK, Int64>.getProp(data.a, data.a.k, degToRads, dp, this.globalData, this.data, types: 0, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            elementData.a.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
            elementData.g = GradientProperty(data.g, this.globalData, this.data, dynamicProperties: this.dynamicProperties)
            elementData.g.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

        }

        if (data.o.size == 1) {
            elementData.o = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(data.o, data.o[0].k ?? 0, 0.01, dp, this.globalData, this.data, types: 0, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
        } else if (data.o.size > 1) {
            elementData.o = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(data.o, data.o, 0, 0.01, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
        }
        //elementData.o = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(data.o, data.o, 0, 0.01, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1)
        elementData.o.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
        if (data.ty == "st" || data.ty == "gs") {
            let lc: Int64 = if (data.lc <= 0){ 2 } else { data.lc }
            styleElem.lc = lineCapEnum[lc]
            let lj: Int64 = if (data.lj <= 0){ 2 } else { data.lj }
            styleElem.lj = lineJoinEnum[lj]
            if (data.lj == 1) { // eslint-disable-line eqeqeq
                styleElem.ml = data.ml
            }

            if (data.w.size == 1) {
                elementData.w = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.w, data.w[0].k ?? 0.0, 0.0, dp, this.globalData, this.data, types: 0, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else if (data.w.size > 1) {
                elementData.w = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.w, data.w, 0, 0.0, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            }
            //elementData.w = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.w, data.w, 0, 0.0, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            elementData.w.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
            if (!elementData.w.k) {
                styleElem.wi = elementData.w.v[0]
            }
            if (data.d.size > 0) {
                var d = DashProperty(data.d, "canvas", this.globalData, this.data, dynamicProperties: this.dynamicProperties)
                elementData.d = d
                elementData.d.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            
                if (!elementData.d.k) {
                    styleElem.da = elementData.d.dashArray
                    //styleElem.do = elementData.d.dashoffset[0]
                    styleElem.dos = elementData.d.dashoffset[0]
                }
            }
        } else {
            if (data.r == 2) {
                styleElem.r = "evenodd"
            }else {
                styleElem.r = "nonzero"
            }
        }
        this.stylesList.append(styleElem)
        elementData.style = styleElem
        return elementData
    }

    public func createGroupElement(datas: ShapeGroup): ShapeGroupElement {
        let elementData = ShapeGroupElement()
        let len: Int64 = datas.it.size
        elementData.it = Array<ContentModelElement>(len, item: empty_ContentModelElement)
        elementData.prevViewData = Array<ContentModelElement>(len, item: empty_ContentModelElement)
        return elementData
    }

    public func createTransformElement(datas: AnimatableTransform) {
        var op: PropertyFactory<ArrayKeyframeInt64, Int64>
        if (datas.o.k.size == 1) {
            op = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(datas.o, datas.o.k[0].k ?? 0, 0.01, dp, this.globalData, this.data, types: 0, dataA: 0, vLen: 1, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
        } else if (datas.o.k.size > 1){
            op = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(datas.o, datas.o.k, 0, 0.01, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
        } else {
            op = PropertyFactory<ArrayKeyframeInt64, Int64>(datas.o, 0.0, dp, this.globalData, this.data, dynamicProperties: this.dynamicProperties)
        }
        op.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

        
        var elementData = TransformInElement(opacity: 1.0,
            _opMdf: false,
            key: this.transformsManager.getNewKey(),
            //(data: T, dataK: Array<Keyframe<E>>, types: Int64, mult: Option<Float64>, container: DynamicPropertyContainer, elemGlobalData: GlobalData, elemData: Layer, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            //op: PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(datas.o, datas.o.k, 0, 0.01, dp, this.globalData, this.data, containerType: 1, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp]),
            op: op,
            mProps: TransformPropertyFactory.getTransformProperty(datas, this.globalData, this.data, dynamicProperties: this.dynamicProperties, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
        )
        return AnimatableTransformElement(elementData)
    }

    public func createShapeElement(data: ContentModel) {
        //TODO: 传入 ShapePropertyFactory 是空的，编译用。
        var elementData = CvShapeData(this.globalData, this.data, data, this.stylesList, this.transformsManager, dynamicProperties: this.dynamicProperties)
        this.shapes.append(elementData)
        this.addShapeToModifiers(elementData)
        return elementData
    }

    public func reloadShapes() {
        var len = this.itemsData.size
        for (i in 0..len) {
            this.prevViewData[i] = this.itemsData[i]
        }
        this.searchShapes(this.shapesData, this.itemsData, this.prevViewData, true, ArrayList<AnimatableTransformElement>())
        len = this.dynamicProperties.size
        for (i in 0..len) {
            this.dynamicProperties[i].getValue()
        }
        //this.renderModifiers()
        this.transformsManager.processSequences(this._isFirstFrame)
    }

    public func addTransformToStyleList(transform: AnimatableTransformElement) {
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
            if (!this.stylesList[i].closed && this.stylesList[i].transforms.size > i) {
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

    public func searchShapes(arr: Array<ContentModel>, itemsData: Array<ContentModelElement>, prevViewData: Array<ContentModelElement>, shouldRender2: Bool, transforms: ArrayList<AnimatableTransformElement>): Unit{
        var shouldRender: Bool = shouldRender2
        var len = arr.size - 1
        var ownStyles =  ArrayList<StyleElem>()
        var ownModifiers = ArrayList<ShapeModifier>()
        var processedPos: Int64 = 0
        //var modifier
        var currentTransform: AnimatableTransformElement
        var ownTransforms: ArrayList<AnimatableTransformElement> = transforms.clone()
        var index = len
        for (i in len..=0: -1) {
            index = i
            processedPos = this.searchProcessedElement(arr[i])
            if (processedPos == 0) {
                arr[i]._shouldRender = shouldRender
            } else {
                itemsData[i] = prevViewData[processedPos - 1]
            }
            if (arr[i].ty == "fl" || arr[i].ty == "st" || arr[i].ty == "gf" || arr[i].ty == "gs") {
                var fs: FillStrokeElement = FillStrokeElement(isNull: true, dynamicProperties: this.dynamicProperties)
                if (processedPos == 0) {
                    fs = this.createStyleElement(arr[i], ownTransforms)
                    itemsData[i] = fs // elementData
                } else {
                    fs = (itemsData[i] as FillStrokeElement).getOrThrow()
                    fs.style.closed = false
                }

                ownStyles.append(fs.style)
            } else if (arr[i].ty == "gr") {
                var gr: ShapeGroupElement = ShapeGroupElement()
                if (processedPos == 0) {
                    gr = this.createGroupElement((arr[i] as ShapeGroup).getOrThrow()) // itemsData
                    itemsData[i] = gr
                } else {
                    gr = (itemsData[i] as ShapeGroupElement).getOrThrow()
                    var jLen = gr.it.size
                    for (j in 0..jLen) {
                        gr.prevViewData[j] = gr.it[j]
                    }
                }
                this.searchShapes((arr[i] as ShapeGroup).getOrThrow().it, gr.it, gr.prevViewData, shouldRender, ownTransforms)
            } else if (arr[i].ty == "tr") {
                if (processedPos == 0) {
                    let at: AnimatableTransform = (arr[i] as AnimatableTransform).getOrThrow()
                    currentTransform = this.createTransformElement(at) //elementData
                    itemsData[i] = currentTransform
                }
                let ate: AnimatableTransformElement = (itemsData[i] as AnimatableTransformElement).getOrThrow()
                ownTransforms.append(ate)
                this.addTransformToStyleList(ate)
            } else if (arr[i].ty == "sh" || arr[i].ty == "rc" || arr[i].ty == "el" || arr[i].ty == "sr") {
                if (processedPos == 0) {
                    itemsData[i] = this.createShapeElement(arr[i]) // CVShapeData
                }
            } else if (arr[i].ty == "tm" || arr[i].ty == "rd" || arr[i].ty == "pb" || arr[i].ty == "zz" || arr[i].ty == "op") {
                var modifier: ShapeModifier = ShapeModifier(arr[i], this.globalData, this.data, dynamicProperties: this.dynamicProperties, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
                if (processedPos == 0) {
                    //modifier = ShapeModifiers.getModifier(arr[i].ty)
                    //modifier.init(this, arr[i])
                    modifier = ShapeModifier(arr[i], this.globalData, this.data, dynamicProperties: this.dynamicProperties, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
                    itemsData[i] = modifier
                    this.shapeModifiers.append(modifier)
                } else {
                    modifier = (itemsData[i] as ShapeModifier).getOrThrow()
                    modifier.closed = false
                }
                ownModifiers.append(modifier)
            } else if (arr[i].ty == "rp") {
                //var modifier: RepeaterModifier = (itemsData[i] as RepeaterModifier).getOrThrow()
                if (processedPos == 0) {
                    //modifier = ShapeModifiers.getModifier(arr[i].ty)
                    //modifier.init(this, arr, i, itemsData)
                    var modifier = RepeaterModifier(arr, i, itemsData, this.globalData, this.data, reloadShapes, dynamicProperties: this.dynamicProperties, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
                    //modifier.compType = 1
                    //modifier.getRenderedFrame = [this.getRenderedFrameInElemComp]
                    itemsData[i] = modifier
                    this.shapeModifiers.append(modifier)
                    shouldRender = false
                } else {
                    var modifier = (itemsData[i] as RepeaterModifier).getOrThrow()
                    modifier.closed = true
                }
                //ownModifiers.append(modifier)
                ownModifiers.append((itemsData[i] as RepeaterModifier).getOrThrow())
            }

            this.addProcessedElement(arr[i], i + 1)
        }
        this.removeTransformFromStyleList()
        this.closeStyles(ownStyles)
        len = ownModifiers.size
        for (i in 0..len) {
            ownModifiers[i].closed = true
        }

    }

    public override func renderInnerContent() {
        this.transformHelper.opacity = 1.0
        this.transformHelper._opMdf = false
        this.renderModifiers()

        this.transformsManager.processSequences(this._isFirstFrame)
        this.renderShape(this.transformHelper, this.shapesData, this.itemsData, isMain:true)
    }

    public func renderShapeTransform(parentTransform: TransformInElement, groupTransform: TransformInElement) {
        if (parentTransform._opMdf || groupTransform.op._mdf || this._isFirstFrame) {
            groupTransform.opacity = parentTransform.opacity
            groupTransform.opacity *= groupTransform.op.v[0]
            groupTransform._opMdf = true
        }
    }

    public func drawLayer() {
        ////Hilog.error(0, "---9--", "----->${currentStyle.preTransforms.finalTransform.props}")
        //var tmps = currentStyle.preTransforms.finalTransform.props

        var len = this.stylesList.size
        //TODO: this.globalData.renderer数据类型是什么？
        //var renderer = this.globalData.renderer
        var ctx = this.globalData.canvasContext
        for (i in 0..len) {
            var currentStyle: StyleElem = this.stylesList[i]
            var types = currentStyle.types

            // Skipping style when
            // Stroke width equals 0
            // style should not be rendered (extra unused repeaters)
            // current opacity equals 0
            // global opacity equals 0
            if (!(((types == "st" || types == "gs") && currentStyle.wi == 0.0) || !currentStyle.data._shouldRender ||
                currentStyle.coOp == 0.0 || this.globalData.currentGlobalAlpha == 0.0)) {
                //TODO: this.globalData.renderer数据类型是什么？
                this.globalData.save(false)

                var elems = currentStyle.elements
                if (types == "st" || types == "gs") {
                    if (types == "st") {
                        ctx.strokeStyle(currentStyle.co)
                    }else {
                        ctx.strokeStyle(currentStyle.grd.getOrThrow())
                    }
                    ctx.lineWidth(currentStyle.wi)
                    //  1: "butt",
                    //  2: "round",
                    //  3: "square",
                    // ctx.lineCap = currentStyle.lc
                    match (currentStyle.lc) {
                    	case "butt" => ctx.lineCap(LineCapStyle.Butt)
                    	case "round" => ctx.lineCap(LineCapStyle.Round)
                    	case "square" => ctx.lineCap(LineCapStyle.Square)
                    	case _ => ctx.lineCap(LineCapStyle.Square)
                    }

                    // ctx.lineJoin = currentStyle.lj
                    //  1: "miter",
                    //  2: "round",
                    //  3: "bevel",
                    match (currentStyle.lj) {
                    	case "miter" => ctx.lineJoin(LineJoinStyle.Miter)
                    	case "round" => ctx.lineJoin(LineJoinStyle.Round)
                    	case "bevel" => ctx.lineJoin(LineJoinStyle.Bevel)
                        case _ => ctx.lineJoin(LineJoinStyle.Miter)
                    }
                    ctx.miterLimit(currentStyle.ml)
                } else {
                    //rgb(36,46,81)
                    if (types == "fl") {
                        ctx.fillStyle(currentStyle.co)
                    }else {
                        ctx.fillStyle(currentStyle.grd.getOrThrow())
                    }
                }
                this.globalData.ctxOpacity(currentStyle.coOp)
                if (types != "st" && types != "gs") {
                    ctx.beginPath()
                }
                //Hilog.error(0, "---9--", "----->${currentStyle.preTransforms.finalTransform.props}")
                var tmps = currentStyle.preTransforms.finalTransform.props
               this.globalData.ctxTransform(currentStyle.preTransforms.finalTransform.props)
                var jLen = elems.size
                for (j in 0..jLen) {
                    if (types == "st" || types == "gs") {
                        ctx.beginPath()
                        if (!currentStyle.da.isEmpty()) {
                            //ctx.setLineDash()无法自动将currentStyle.da拆分为两个参数，导致传入接口参数个数不正确，所以这里需要手动拆分
                            //判断currentStyle.da数组长度是否大于等于2，如果是则把数组的值取出来，传给ctx.setLineDash()方法
                            if (currentStyle.da.size >= 2) {
                                var s1 = currentStyle.da[0]
                                var s2 = currentStyle.da[1]
                                //lineDash 对应 setLineDash
                                ctx.lineDash([s1, s2])
                            } else {
                                var s1 = currentStyle.da[0]
                                ctx.lineDash([s1])
                            }
                            ctx.lineDashOffset(currentStyle.dos)
                        }
                    }
                    var nodes = elems[j].trNodes
                    var kLen = nodes.size
                    //Hilog.error(0, "", "测试【trNodes】-- kLen = ${kLen} ------------------------------------------")
                    for (k in 0..kLen) {
                        if (nodes[k].t == "m") {
                            ctx.moveTo(nodes[k].p[0], nodes[k].p[1])
                            //TODO：调试用，后续删除
                            //ctx.moveTo(30, 30)
                        } else if (nodes[k].t == "c") {
                            ctx.bezierCurveTo(nodes[k].pts[0], nodes[k].pts[1], nodes[k].pts[2], nodes[k].pts[3], nodes[k].pts[4], nodes[k].pts[5])
                            //TODO：调试用，后续删除
                            //ctx.bezierCurveTo(20, 100, 200, 100, 200, 20)
                        } else {
                            ctx.closePath()
                        }
                    }
                    if (types == "st" || types == "gs") {
                        ctx.stroke()
                        if (currentStyle.da.size > 0) {
                            ctx.lineDash(this.dashResetter())
                        }
                    }
                }
                if (types != "st" && types != "gs") {
                    //其实fill方法有两个参数可选：nonzero | evenodd ，“nonzero”是非零环绕原则，也是默认值，“evenodd”为奇偶原则
                    ctx.fill()
                }
                //renderer.restore()
                this.globalData.restore(false)
            }
        }
    }

    public override func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64) {
        if(index == 0){
            this.renderShapeColor(color,endColor)
        }
    }

    public override func renderShapeColor(color: Array<Int64>,endColor: Int64) {
        var items = this.shapesData
        var data = this.itemsData
        this.renderShapeColor(color,endColor,items,data)
    }

    // SEE
    public func renderShapeColor(color: Array<Int64>, endColor:Int64, items: Array<ContentModel>, data: Array<ContentModelElement>): Unit {
        var len = items.size - 1
        var i = len
        while ( i >= 0) {
            if (items[i].ty == "fl" || items[i].ty == "st") {
                //  data[i] 类型为StyleElement
//                if (color.size == 4) {
//                    data[i].c.v[0] = color[0]
//                    data[i].c.v[1] = color[1]
//                    data[i].c.v[2] = color[2]
//                    data[i].o.v = color[3]
//                  } else if (color.size == 3) {
//                    data[i].c.v[0] = color[0]
//                    data[i].c.v[1] = color[1]
//                    data[i].c.v[2] = color[2]
//                  } else if (color.size == 2) {
//                    data[i].c.v[0] = color[0]
//                    data[i].c.v[2] = color[1]
//                  } else if (color.size == 1) {
//                    data[i].c.v[0] = color[0]
//                  }
            } else if (items[i].ty == "gr") {
                this.renderShapeColor(color, endColor, (items[i] as ShapeGroup).getOrThrow().it, (data[i] as ShapeGroupElement).getOrThrow().it)
            } else if (items[i].ty == "gf" || items[i].ty == "gs") {
//                try {
                    //data[i].style.grd = undefined
                    var lens = 3
                    for (j in 0..lens) {
                        //data[i] 类型为StyleElement
//                          if (color.size >= 3) {
//                            data[i].g.c[j * 4 + 1] = color[0]
//                            data[i].g.c[j * 4 + 2] = color[1]
//                            data[i].g.c[j * 4 + 3] = color[2]
//                          } else if (color.size == 2) {
//                            data[i].g.c[j * 4 + 1] = color[0]
//                            data[i].g.c[j * 4 + 2] = color[1]
//                          } else if (color.size == 1) {
//                            data[i].g.c[j * 4 + 1] = color[0]
//                          }
                    }
//                  } catch (e: Exception) {
//                  }
            }
            i -= 1
        }
    }

    //items: ContentModel-->ShapeGroup
    //TODO: 对标 CVShapeElement.prototype.renderShapeColor
    public func renderShapeColor(color2: Array<Int64>, endColor2: Array<Int64>, items: Array<ContentModel>, data: Array<ContentModelElement>): Unit {
        var color: Array<Float64> = Array<Float64>(color2.size, {i => Float64(color2[i])})
        var endColor: Array<Float64> = Array<Float64>(endColor2.size, {i => Float64(endColor2[i])})
        this.renderShapeColor(color, endColor, items, data)
    }

    //TODO: 对标 CVShapeElement.prototype.renderShapeColor
    public func renderShapeColor(color: Array<Float64>, endColor: Array<Float64>, items2: Array<ContentModel>, data2: Array<ContentModelElement>): Unit {
        var items: Array<ContentModel> = items2
        var data: Array<ContentModelElement> = data2
        if (items.size == 0 || data.size == 0) {
            items = this.shapesData
            data = this.itemsData
        }
        var len: Int64 = items.size - 1
        var i: Int64 = len
        while ( i >= 0) {
            if (items[i].ty == "fl" || items[i].ty == "st") {
                //  data[i] 类型为StyleElement
                //let fillStroke: FillStroke = (data[i] as FillStroke).getOrThrow()
                let fse: FillStrokeElement = (items[i] as FillStrokeElement).getOrThrow()
                if (endColor.size > 0) {
                    var c_data_k_s: Array<Float64> = Array<Float64>()
                    if (let Some(v) <- fse.c.data[0].s) {
                        c_data_k_s = v
                    }
                    var c_data_k_e: Array<Float64> = Array<Float64>()
                    if (let Some(v) <- fse.c.data[0].e) {
                        c_data_k_e = v
                    }
                    if (color.size == 4) {
                        c_data_k_s[0] = color[0] / 255.0
                        c_data_k_s[1] = color[1] / 255.0
                        c_data_k_s[2] = color[2] / 255.0

                        c_data_k_e[0] = endColor[0] / 255.0
                        c_data_k_e[1] = endColor[1] / 255.0
                        c_data_k_e[2] = endColor[2] / 255.0

                        fse.o.v = [Float64(color[3])]
                    } else if (color.size == 3) {
                      c_data_k_s[0] = color[0] / 255.0
                      c_data_k_s[1] = color[1] / 255.0
                      c_data_k_s[2] = color[2] / 255.0

                      c_data_k_e[0] = endColor[0] / 255.0
                      c_data_k_e[1] = endColor[1] / 255.0
                      c_data_k_e[2] = endColor[2] / 255.0
                    } else if (color.size == 2) {
                      c_data_k_s[0] = color[0] / 255.0
                      c_data_k_s[2] = color[1] / 255.0

                      c_data_k_e[0] = endColor[0] / 255.0
                      c_data_k_e[2] = endColor[1] / 255.0
                    } else if (color.size == 1) {
                      c_data_k_s[0] = color[0] / 255.0
                      c_data_k_e[0] = endColor[0] / 255.0
                    }
                } else {
                    if (color.size == 4) {
                        fse.c.v[0] = color[0]
                        fse.c.v[1] = color[1]
                        fse.c.v[2] = color[2]
                        fse.o.v = [color[3]]
                    } else if (color.size == 3) {
                        fse.c.v[0] = color[0]
                        fse.c.v[1] = color[1]
                        fse.c.v[2] = color[2]
                    } else if (color.size == 2) {
                        fse.c.v[0] = color[0]
                        fse.c.v[2] = color[1]
                    } else if (color.size == 1) {
                        fse.c.v[0] = color[0]
                    }
                }
            } else if (items[i].ty == "gr") {
                // data[i]------->ShapeGroupElement
                this.renderShapeColor(color, endColor, (items[i] as ShapeGroup).getOrThrow().it, (data[i] as ShapeGroupElement).getOrThrow().it)
            } else if (items[i].ty == "gf" || items[i].ty == "gs") {
//                try {
                    let fse: FillStrokeElement = (items[i] as FillStrokeElement).getOrThrow()
                    //data[i].style.grd = undefined
                    var lens = 3
                    for (j in 0..lens) {
                        //data[i] 类型为StyleElement
                        if (color.size >= 3) {
                          fse.g.c[j * 4 + 1] = color[0]
                          fse.g.c[j * 4 + 2] = color[1]
                          fse.g.c[j * 4 + 3] = color[2]
                        } else if (color.size == 2) {
                          fse.g.c[j * 4 + 1] = color[0]
                          fse.g.c[j * 4 + 2] = color[1]
                        } else if (color.size == 1) {
                          fse.g.c[j * 4 + 1] = color[0]
                        }
                    }
//                } catch (e: Exception) {
//                }
            }
            i -= 1
        }
    }

    public override func renderShapeColor(color: Array<Int64>,endColor: Array<Int64>,itemes: Int64) {
        if(itemes ==0) {
            var items = this.shapesData
            var data = this.itemsData
            this.renderShapeColor(color,endColor,items,data)
        }
    }

    //public func renderShape(parentTransform: TransformHelpers, items: Array<ShapeDataInCV>, data: Array<ItemData>, isMain!: Bool = false): Unit {
    public func renderShape(parentTransform: TransformInElement, items: Array<ContentModel>, data: Array<ContentModelElement>,
        isMain!: Bool = false): Unit {
        var len = items.size - 1
        var groupTransform = parentTransform
        var i = len
        while (i >= 0) {
            let ity = items[i].ty
            if (ity == "tr") {
                groupTransform = (data[i] as AnimatableTransformElement).getOrThrow().transform
                this.renderShapeTransform(parentTransform, groupTransform)
            }
            else if (ity == "sh" || ity == "el" || ity == "rc" || ity == "sr") {
                this.renderPath(items[i], data[i])
            }
            else if (ity == "fl") {
                this.renderFill(items[i], (data[i] as FillStrokeElement).getOrThrow(), groupTransform)
            }
            else if (ity == "st") {
                this.renderStroke(items[i], (data[i] as FillStrokeElement).getOrThrow(), groupTransform)
            }
            else if (ity == "gf" || ity == "gs") {
                this.renderGradientFill((items[i] as FillStroke).getOrThrow(), (data[i] as FillStrokeElement).getOrThrow(), groupTransform)
            }
            else if (ity == "gr") {
                this.renderShape(groupTransform, (items[i] as ShapeGroup).getOrThrow().it, (data[i] as ShapeGroupElement).getOrThrow().it)
            }
            else if (ity == "tm") {
                //
            }
            i -= 1
        }
        if (isMain) {
            this.drawLayer()
        }
    }

    public func renderStyledShape(styledShape: StyledShape, shape: ShapePropertyFactory) {  //see
        if (this._isFirstFrame || shape._mdf || styledShape.transforms._mdf) {
            var shapeNodes = styledShape.trNodes
            var paths: ShapeCollection = shape.paths
            var len: Int64 = 0
            var i = 0
            var jLen = paths._length
            shapeNodes.clear()
            var groupTransformMat = styledShape.transforms.finalTransform
            for (j in 0..jLen) {
                var pathNodesos: Option<ShapeData> = paths.shapes.get(j)
                if (let Some(pathNodes) <- pathNodesos) {
                    if (pathNodes.v.size > 0) {
                        //Hilog.error(0, "", "测试【trNodes】-2-- pathNodes._length = ${pathNodes._length} ------------------------------------------")
                        len = pathNodes._length
                        for (index in 1..len) {
                            if (index == 1) {
                                shapeNodes.append(StyledShapeTrNodes("m",
                                    p: groupTransformMat.applyToPointArray(pathNodes.v[0].x, pathNodes.v[0].y, 0.0)
                                ))
                            }
                            shapeNodes.append(StyledShapeTrNodes("c",
                                pts: groupTransformMat.applyToTriplePoints([pathNodes.o[index - 1].x,pathNodes.o[index - 1].y], [pathNodes.i[index].x,pathNodes.i[index].y], [pathNodes.v[index].x,pathNodes.v[index].y])
                            ))
                            i = index
                        }
                        if (len == 1) {
                            shapeNodes.append(StyledShapeTrNodes("m", p: groupTransformMat.applyToPointArray(pathNodes.v[0].x, pathNodes.v[0].y, 0.0)))
                        }
                        if (pathNodes.c  && len > 0) {
                            //let aaa = groupTransformMat.applyToTriplePoints(
                            //                                                [pathNodes.o[i].x,pathNodes.o[i].y],
                            //                                                [pathNodes.i[0].x,pathNodes.i[0].y],
                            //                                                [pathNodes.v[0].x,pathNodes.v[0].y]
                            //                                                )
                            shapeNodes.append(StyledShapeTrNodes("c",
                                pts: groupTransformMat.applyToTriplePoints(
                                                                            [pathNodes.o[i].x,pathNodes.o[i].y],
                                                                            [pathNodes.i[0].x,pathNodes.i[0].y],
                                                                            [pathNodes.v[0].x,pathNodes.v[0].y]
                                                                            )
                            ))
                            shapeNodes.append(StyledShapeTrNodes( "z"))
                        }
                    }
                }

            }
            styledShape.trNodes = shapeNodes
            //Hilog.error(0, "", "测试【trNodes】-3-- shapeNodes.size = ${shapeNodes.size} ------------------------------------------")
        }
    }

    //public func renderPath(pathData: ShapeDataInCV, itemData: Object) {
    public func renderPath(pathData: ContentModel, itemDatas: ContentModelElement) {
        var itemData = (itemDatas as CvShapeData).getOrThrow()
        if (pathData.hd != true && pathData._shouldRender) {
            var len = itemData.styledShapes.size
            for (i in 0..len) {
                this.renderStyledShape(itemData.styledShapes[i], itemData.sh)
            }
        }
    }

    public func renderFill(styleData: ContentModel, itemData: FillStrokeElement, groupTransform: TransformInElement) {
        var styleElem = itemData.style
        if (itemData.c._mdf || this._isFirstFrame) {
            //styleElem.co = "rgb(" + "${floor(itemData.c.v[0])}" + "," + "${floor(itemData.c.v[1])}" + "," + "${floor(itemData.c.v[2])}" + ")"
            //TODO: 测试观察用，后续删除
            let a = floor(itemData.c.v[0])
            let b = floor(itemData.c.v[1])
            let c = floor(itemData.c.v[2])
            //Hilog.error(0, "", "[renderFill]: itemData.c.v = ${itemData.c.v}")
            //Hilog.error(0, "", "[renderFill]: a = ${a}, b = ${b}, c = ${c}")
            styleElem.co = Color(UInt8(floor(itemData.c.v[0])), UInt8(floor(itemData.c.v[1])), UInt8(floor(itemData.c.v[2])))
        }
        if (itemData.o._mdf || groupTransform._opMdf || this._isFirstFrame) {
            //TODO: 测试观察用，后续删除
            //Hilog.error(0, "", "[renderFill]: itemData.o.v[0] = ${itemData.o.v[0]}")
            //Hilog.error(0, "", "[renderFill]: groupTransform.opacity = ${groupTransform.opacity}")
            styleElem.coOp = Float64(itemData.o.v[0]) * groupTransform.opacity
        }
    }

    public func renderGradientFill(styleData: FillStroke, itemData: FillStrokeElement, groupTransform: TransformInElement) {
        var styleElem: StyleElem = itemData.style
        var grd: CanvasGradient
        //TODO: FillStrokeElement.h 成员变量暂时是空的。
        //if (!styleElem.hasgrd || itemData.g._mdf || itemData.s._mdf || itemData.e._mdf || (styleData.t != 1 && (itemData.h._mdf || itemData.a._mdf)))
        if (!styleElem.hasgrd || itemData.g._mdf || itemData.s._mdf || itemData.e._mdf || (styleData.t != 1 && itemData.a._mdf)) {
            var ctx = this.globalData.canvasContext
            var pt1 = itemData.s.v
            var pt2 = itemData.e.v
            if (styleData.t == 1) {
                grd = ctx.createLinearGradient(pt1[0], pt1[1], pt2[0], pt2[1])
            } else {
                var rad = sqrt(pow(pt1[0] - pt2[0], 2) + pow(pt1[1] - pt2[1], 2))
                /**
                 * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
                 * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
                 * Math.atan2(p[1], p[0]) = atan(p[1] / p[0])
                 */
                var ang = atan((pt2[1] - pt1[1]) / (pt2[0] - pt1[0]))

                //TODO: FillStrokeElement.h 成员变量暂时是空的。其中的 v 会默认取值为 v = initFrame = initialDefaultFrame = -999999
                //var percent = itemData.h.v
                var percent = -999999.0
                if (percent >= 1.0) {
                    percent = 0.99
                } else if (percent <= -1.0) {
                    percent = -0.99
                }
                var dist = rad * percent
                var x = cos(ang + itemData.a.v[0]) * dist + pt1[0]
                var y = sin(ang + itemData.a.v[0]) * dist + pt1[1]
                grd = ctx.createRadialGradient(x, y, 0.0, pt1[0], pt1[1], rad)
            }

            var len = styleData.g.p
            var cValues = itemData.g.c
            var opacity = 1.0

            for (i in 0..len) {
                if (itemData.g._hasOpacity != 0 && itemData.g._collapsable) {
                    opacity = itemData.g.o[i * 2 + 1]
                }
                //grd.addColorStop(cValues[i * 4] / 100.0, 'rgba(' + cValues[i * 4 + 1] + ',' + cValues[i * 4 + 2] + ',' + cValues[i * 4 + 3] + ',' + opacity + ')')
                let color: Color = Color(UInt8(cValues[i * 4 + 1]), UInt8(cValues[i * 4 + 2]), UInt8(cValues[i * 4 + 3]), alpha: Float32(opacity))
                grd.addColorStop(cValues[i * 4] / 100.0, color)
            }
            styleElem.grd = grd
        }
        styleElem.coOp = itemData.o.v[0] * groupTransform.opacity
    }


    public func renderStroke(styleData: ContentModel, itemData: FillStrokeElement, groupTransform: TransformInElement) {
        var styleElem = itemData.style
        var d = itemData.d
        if (d._mdf || this._isFirstFrame) {
            styleElem.da = d.dashArray
            styleElem.dos = d.dashoffset[0]
        }
        if (itemData.c._mdf || this._isFirstFrame) {
            //styleElem.co = "rgb(" + "${floor(itemData.c.v[0])}" + "," + "${floor(itemData.c.v[1])}" + "," + "${floor(itemData.c.v[2])}" + ")"
            styleElem.co = Color(UInt8(floor(itemData.c.v[0])), UInt8(floor(itemData.c.v[1])), UInt8(floor(itemData.c.v[2])))
        }
        if (itemData.o._mdf || groupTransform._opMdf || this._isFirstFrame) {
            styleElem.coOp = itemData.o.v[0] * groupTransform.opacity
        }
        if (itemData.w._mdf || this._isFirstFrame) {
            styleElem.wi = itemData.w.v[0]
        }
    }

    public override func destroy() {
        this.shapesData = Array<ContentModel>()
        // this.globalData = null
        // this.canvasContext = null
        this.stylesList.clear()
        this.itemsData =Array<ContentModelElement>()
    }

}
