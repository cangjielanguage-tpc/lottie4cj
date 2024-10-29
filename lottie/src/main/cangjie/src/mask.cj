/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is MaskElement.
 */
package lottie
//package lottie.elements

internal import std.collection.*

internal import lottie.model.*
internal import lottie.elements.*
internal import lottie.utils.helpers.*
internal import lottie.global_data.*
internal import lottie.property.*
internal import lottie.bezier.*
internal import lottie.inner.*

/* 调用 MaskElement 的 init 后要立即调用 initEndDrawPath 和 initEndAddRenderableComponent。 */
public open class MaskElement <: BaseElement {

    var element: BaseElement
    
    //TODO: StoredData 自定义数据类型。
    var storedData: ArrayList<StoredData> = ArrayList<StoredData>(24)
    var masksProperties: Array<Mask> = Array<Mask>()
    var maskElement: CreateNS = CreateNS("")
    //TODO: ViewData 自定义数据类型。
    var viewData: Array<ViewData> = Array<ViewData>()
    var solidPath: String = ""

    /* 调用init后要立即调用 initEndDrawPath 和 initEndAddRenderableComponent。 */
    public init(data: Layer, element: BaseElement, globalData: GlobalData) {
        super(data, globalData)
        this.data = data
        this.element = element
        this.globalData = globalData

        this.masksProperties = this.data.masksProperties
        let defs: CreateNS = this.globalData.defs

        var len: Int64 = this.masksProperties.size
        
        //需要初始化一个空的 ViewData。
        let dp: DynamicPropertyContainer = DynamicPropertyContainer(globalData, data, dynamicProperties: this.dynamicProperties)
        let pf: PropertyFactory<Array<Keyframe<Int64>>, Int64> = PropertyFactory<Array<Keyframe<Int64>>, Int64>(Array<Keyframe<Int64>>(), 0.0, dp, globalData, data, dynamicProperties: dynamicProperties)
        let spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, globalData, data, dynamicProperties: dynamicProperties)
        let emptyViewData: ViewData = ViewData(op: pf, props: spf)
        this.viewData = Array<ViewData>(len, item: emptyViewData)
        
        let empty_createNS: CreateNS = CreateNS("")
    
        var path: CreateNS = empty_createNS
        var properties: Array<Mask> = this.masksProperties
        var count: Int64 = 0
        var currentMasks: ArrayList<CreateNS> = ArrayList<CreateNS>(24)

        var jLen: Int64 = 0
        let layerId: String = CreateElementID.createID()
        
        var rect: CreateNS = empty_createNS
        var expansor: CreateNS = empty_createNS
        var feMorph: CreateNS = empty_createNS

        //TODO: 先初始化一个空的 x
        var x: PropertyFactory<Array<Keyframe<Int64>>, Int64> = PropertyFactory<Array<Keyframe<Int64>>, Int64>(Array<Keyframe<Int64>>(), 0.0, dp, globalData, data, dynamicProperties: dynamicProperties)
        
        var maskType: String = "clipPath"
        var maskRef: String = "clip-path"
        for (i in 0..len) {
            //TODO: 暂时在 json 中未找到 masksProperties.o.x  //if ((properties[i].mode != "a" && properties[i].mode != "n") || properties[i].inv || (properties[i].o.size > 0 && properties[i].o[0].x != 0.0))
            if ((properties[i].mode != "a" && properties[i].mode != "n") || properties[i].inv) {
                maskType = "mask"
                maskRef = "mask"
            } else if (properties[i].o.size == 1) {
                let k: Int64 = properties[i].o[0].k ?? 0
                if (k != 100) {
                    maskType = "mask"
                    maskRef = "mask"
                }
            }
    
            if ((properties[i].mode == "s" || properties[i].mode == "i") && count == 0) {
                rect = CreateNS("rect")
                rect.setAttribute("fill", "#ffffff")
                /*
                 * TODO: this.element.comp 还未确认是否有循环引用问题，暂时没有关联。
                 * //rect.setAttribute("width", this.element.comp.data.w.toString())
                 * //rect.setAttribute("height", this.element.comp.data.h.toString())
                 */
                currentMasks.append(rect)
            } else {
                rect = empty_createNS
            }

            //数据来源分析：masksProperties.o => "o":{"k":100}   =>  properties[i].o = _o: Array<Keyframe<Int64>>
            let op: PropertyFactory<Array<Keyframe<Int64>>, Int64>
            if (properties[i].o.size == 1) {
                //TODO: PropertyFactory.getProp 传入的参数是 MaskElement，不是 DynamicPropertyContainer？？？
                //TODO: 暂时先传入 DynamicPropertyContainer。
                op = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(properties[i].o, properties[i].o[0].k ?? 0, 0.01, dp, globalData, data, dynamicProperties: dynamicProperties, containerType: 1)//, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else if (properties[i].o.size > 1) {
                op = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(properties[i].o, properties[i].o, 0, 0.01, dp, globalData, data, dynamicProperties: dynamicProperties, containerType: 1)//, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
            } else {
                op = PropertyFactory<Array<Keyframe<Int64>>, Int64>(properties[i].o, 0.01, dp, globalData, data, dynamicProperties: dynamicProperties)
            }
            op.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

            let props: ShapePropertyFactory = ShapePropertyFactory.getShapeProp(properties[i], 3, globalData, data, dynamicProperties: dynamicProperties)
            props.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property


            path = CreateNS("path")
            if (properties[i].mode == "n") {
                // TODO move this to a factory or to a constructor
                //TODO: 是否合并 StoredData 和 ViewData？？？
                this.viewData[i] = ViewData(
                    op: op,
                    props: props,
                    elem: path,
                    lastPath: ""
                )
                defs.appendChild(path)
            } else {
                count += 1
    
                var fillStr: String = "#ffffff"
                if (properties[i].mode == "s") {
                    fillStr = "#000000"
                }
                path.setAttribute("fill", fillStr)
                path.setAttribute("clip-rule", "nonzero")
                var filterID: String = ""

                if (properties[i].x.size == 1) {
                    let k: Int64 = properties[i].x[0].k ?? 0
                    
                    //if (properties[i].x.k != 0) {
                    if (k != 0) {
                        maskType = "mask"
                        maskRef = "mask"
                        /*
                         * "x":{"k":0}  =>  _x: Array<Keyframe<Int64>>
                         * TODO: layers[i].masksProperties.x 有几种数据类型？？？   //TODO: 暂定就是 "x":{"k":0}。
                         * TODO: PropertyFactory.getProp 传入的参数是 MaskElement，不是 DynamicPropertyContainer？？？  //TODO: 暂时先传入 DynamicPropertyContainer。
                         */  //TODO: 暂时先传入 DynamicPropertyContainer。
                        x = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(properties[i].x, k, 0.0, dp, globalData, data, dynamicProperties: dynamicProperties, containerType: 1)//, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
                        filterID = CreateElementID.createID()
                        expansor = CreateNS("filter")
                        expansor.setAttribute("id", filterID)
                        feMorph = CreateNS("feMorphology")
                        feMorph.setAttribute("operator", "erode")
                        feMorph.setAttribute("in", "SourceGraphic")
                        feMorph.setAttribute("radius", "0")
                        expansor.appendChild(feMorph)
                        defs.appendChild(expansor)
                        path.setAttribute("stroke", fillStr)
                    } else {
                        feMorph = empty_createNS
                        //TODO: x 在定义式已经先初始化一个空的 PropertyFactory。
                    }
                } else if (properties[i].x.size > 1) {
                    //TODO: PropertyFactory.getProp 传入的参数是 MaskElement，不是 DynamicPropertyContainer？？？  //TODO: 暂时先传入 DynamicPropertyContainer。
                    x = PropertyFactory<Array<Keyframe<Int64>>, Int64>.getProp(properties[i].x, properties[i].x, 0, 0.0, dp, globalData, data, dynamicProperties: dynamicProperties, containerType: 1)//, compType: 1, renderedFrame: [this.getRenderedFrameInElemComp])
                }
                x.containerType = 1  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property

                        
                // TODO: 将其移动到工厂或构造函数
                this.storedData[i] = StoredData(
                    elem: path,
                    x: x,
                    expan: feMorph,
                    lastPath: '',
                    lastOperator: '',
                    filterId: filterID,
                    lastRadius: 0
                )
                if (properties[i].mode == "i") {
                    jLen = currentMasks.size
                    var g: CreateNS = CreateNS("g")
                    for (j in 0..jLen) {
                        g.appendChild(currentMasks[j])
                    }
                    var mask = CreateNS("mask")
                    mask.setAttribute("mask-type", "alpha")
                    mask.setAttribute("id", layerId + "_" + count.toString())
                    mask.appendChild(path)
                    defs.appendChild(mask)
                    g.setAttribute("mask", "url(" + getLocationHref() + "#" + layerId + "_" + count.toString() + ")")
    
                    currentMasks.clear()
                    currentMasks.append(g)
                } else {
                    currentMasks.append(path)
                }
                /*
                 * TODO: 无法在此处初始化 solidPath。
                 * 调用条件：if (properties[i].mode != 'n') && (properties[i].inv && !this.solidPath)
                 * 处理方案：1. 在使用时进行符合条件判断，符合时调用 createLayerSolidPath() 赋值？？？
                 * 2. 在 MaskElement 初始化后，手动调用一下包装过的函数 【initEndDrawPath】。 -- 【应用此方案】
                 * if (properties[i].inv && this.solidPath == "") { this.solidPath = createLayerSolidPath() }
                 */

                // TODO move this to a factory or to a constructor
                this.viewData[i] = ViewData(
                    op: op,
                    props: props,
                    elem: path,
                    lastPath: "",
                    invRect: rect
                )
                /*
                 * TODO: 无法在此处调用 drawPath。
                 * drawPath 函数是将参数1和2进行处理，结构封装到参数3(this.viewData[i])中。
                 * 调用条件：只在 (properties[i].mode != "n")  且 (!this.viewData[i].props.k) 时，调用 drawPath 函数。
                 * 处理方案：
                 * - 在 MaskElement 初始化后，手动调用一下包装过的函数 【initEndDrawPath】。
                 * if (!this.viewData[i].props.k) { this.drawPath(properties[i], this.viewData[i].props.v, this.viewData[i]) }
                 */
            }
        }
    
        this.maskElement = CreateNS(maskType)
    
        len = currentMasks.size
        for (i in 0..len) {
            this.maskElement.appendChild(currentMasks[i])
        }
    
        if (count > 0) {
            this.maskElement.setAttribute("id", layerId)
            //TODO: maskedElement 在 MaskElement 中编译用。
            this.element.maskedElement.setAttribute(maskRef, "url(" + getLocationHref() + "#" + layerId + ")")
            defs.appendChild(this.maskElement)
        }
        /*
         * TODO: 无法在此处调用 addRenderableComponent。
         * 处理方案：
         * - 在 MaskElement 初始化后，手动调用一下 【initEndAddRenderableComponent】，即包装过的 this.element.addRenderableComponent(this) ？？？
         * if (this.viewData.size != 0) { this.element.addRenderableComponent(this) }
         */
    }
    
    public func initEndAddRenderableComponent(): Unit {
        if (this.viewData.size != 0) {
            //TODO: 暂未实现 addRenderableComponent。
            this.element.addRenderableComponent(this)
        }
    }
    
    public func initEndDrawPath(): Unit {
        let properties: Array<Mask> = this.masksProperties
        let len: Int64 = this.masksProperties.size
        for (i in 0..len) {
            if (properties[i].mode != "n") {
                if (properties[i].inv && this.solidPath == "") {
                    this.solidPath = createLayerSolidPath()
                }
                if (!this.viewData[i].props.k) {
                    this.drawPath(properties[i], this.viewData[i].props.v, this.viewData[i])
                }
            }
        }
    }

    public func getMaskProperty(pos: Int64): ShapePropertyFactory {
        return this.viewData[pos].props
    }

    public func renderFrame(isFirstFrame: Bool): Unit {
        //TODO：父3类 TransformElement 中有 finalTransform，但是暂未和 BaseElement 编译关联起来。
        let finalMat: Matrix = this.element.finalTransform.mat
        let len: Int64 = this.masksProperties.size
        for (i in 0..len) {
            if (this.viewData[i].props._mdf || isFirstFrame) {
                this.drawPath(this.masksProperties[i], this.viewData[i].props.v, this.viewData[i])
            }
            if (this.viewData[i].op._mdf || isFirstFrame) {
                this.viewData[i].elem.setAttribute("fill-opacity", this.viewData[i].op.v[0].toString())
            }
            if (this.masksProperties[i].mode != "n") {
                //TODO：父3类 TransformElement 中有 finalTransform，但是暂未和 BaseElement 编译关联起来。
                if (this.viewData[i].invRect.isNull && (this.element.finalTransform.mProp._mdf || isFirstFrame)) {
                    this.viewData[i].invRect.setAttribute("transform", finalMat.getInverseMatrix().to2dCSS())
                }
                if (this.storedData[i].x.isNull && (this.storedData[i].x._mdf || isFirstFrame)) {
                    var feMorph: CreateNS = this.storedData[i].expan
                    if (this.storedData[i].x.v[0] < 0.0) {
                        if (this.storedData[i].lastOperator != "erode") {
                            this.storedData[i].lastOperator = "erode"
                            this.storedData[i].elem.setAttribute("filter", "url(" + getLocationHref() + "#" + this.storedData[i].filterId + ")")
                        }
                        feMorph.setAttribute("radius", (-this.storedData[i].x.v[0]).toString())
                    } else {
                        if (this.storedData[i].lastOperator != "dilate") {
                            this.storedData[i].lastOperator = "dilate"
                            this.storedData[i].elem.setAttribute("filter", "")
                        }
                        this.storedData[i].elem.setAttribute("stroke-width", (this.storedData[i].x.v[0] * 2.0).toString())
                    }
                }
            }
        }
    }
    
    public func getMaskelement(): CreateNS {
        return this.maskElement
    }
    
    public func createLayerSolidPath(): String {
        var path: String = "M0,0 "
        path += " h" + this.globalData.compSize.w.toString()
        path += " v" + this.globalData.compSize.h.toString()
        path += " h-" + this.globalData.compSize.w.toString()
        path += " v-" + this.globalData.compSize.h.toString() + " "
        return path
    }

    //TODO: path 相关的 (x, y) 位置点，是否需要换成 Int64 数据类型？？？
    public func drawPath(pathData: Mask, pathNodes: ShapeData, viewData: ViewData): Unit {
        var pathString: String = " M" + pathNodes.v[0].x.toString() + "," + pathNodes.v[0].y.toString()
        let len: Int64 = pathNodes._length
        for (i in 1..len) {
            pathString += " C" + pathNodes.o[i - 1].x.toString() + "," + pathNodes.o[i - 1].y.toString() + " " + pathNodes.i[i].x.toString() + "," + pathNodes.i[i].y.toString() + " " + pathNodes.v[i].x.toString() + "," + pathNodes.v[i].y.toString()
        }
        if (pathNodes.c && len > 1) {
            //TODO: 此时 i == len
            pathString += " C" + pathNodes.o[len - 1].x.toString() + "," + pathNodes.o[len - 1].y.toString() + " " + pathNodes.i[0].x.toString() + "," + pathNodes.i[0].y.toString() + " " + pathNodes.v[0].x.toString() + "," + pathNodes.v[0].y.toString()
        }
    
        if (viewData.lastPath != pathString) {
            var pathShapeValue = ""
            if (viewData.elem.isNull) {
                if (pathNodes.c) {
                    pathShapeValue = pathString
                    if (pathData.inv) {
                        pathShapeValue = this.solidPath + pathString
                    }
                }
                viewData.elem.setAttribute("d", pathShapeValue)
            }
            viewData.lastPath = pathString
        }
    }
    
    public func destroy(): Unit {
        //TODO: element 怎么清理？？？
        //this.element = null
        this.globalData = GlobalData()
        this.maskElement = CreateNS("")
        this.data = Layer()
        this.masksProperties = Array<Mask>()
    }

}
