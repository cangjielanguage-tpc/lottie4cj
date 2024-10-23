/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a BaseRenderer.
 */
package lottie.renderers

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.hilog.*

internal import lottie.model.*
internal import lottie.elements.*
internal import lottie.elements.helpers.*
//internal import lottie.animation.*
internal import lottie.global_data.*
internal import lottie.bezier.*
internal import lottie.utils.*
internal import lottie.utils.helpers.*

internal import std.collection.*

public type CreateTag = CreateNS

public open class BaseRenderer {

    /*
     * TODO：解构以下 AnimationItem 和 Renderer。
     * this.animationItem.wrapper
     * this.animationItem.container
     * this.animationItem._isFirstFrame
     * this.animationItem.contentMode
     */
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //TODO: 初始化一个空的 CanvasRenderingContext2D。
    public var wrapperInAnimationItem: CanvasRenderingContext2D

    /*
     * 数据类型推测路线：
     * this.canvasContext = this.renderConfig.context
     * this.canvasContext = this.animationItem.wrapper
     * [AnimationItem] this.wrapper = params.wrapper || params.container ( params <=> loadAnimation(params) )
     *   =>  CanvasRenderingContext2D = this.canvasContext = this.renderConfig.context
     */
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //CanvasRendererBase 中挪过来的。
    public var canvasContext: CanvasRenderingContext2D

    //TODO: 字符串不能直接传递，否则 animationItem.contentMode 中修改，此处不会修改。
    //TODO: 不确定 this.animationItem.container数据类型暂定为 CreateNS。【对应的是html渲染的 hide/show】。
    //public var containerInAnimationItem: CreateNS = CreateNS("")

    public var _isFirstFrameInAnimationItem: () -> Float64 = { => 0.0 }
    //TODO：this.animationItem.contentMode 的值是可变的，故不能直接传值，需要通过函数【contentModeInAnimationItem】间接获取当时值。
    public var contentModeInAnimationItem: () -> String = { => "" }

    public var rendererType: String = ""

    /**
     * //TODO: 需要解构 BaseRenderer 和 BaseElement 互调用。
     * //TODO: 将 BaseRenderer 中的 elements 和 pendingElements，放到 BaseElement 中
     * 
     * //TODO: elements 数据类型是 BaseElement/BaseRenderer，暂定是 BaseElement
     * public var elements: Array<BaseElement> = Array<BaseElement>()
     * //TODO: 数据类型未确认，暂定是 BaseElement
     * public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()
     */

    public var layers: Array<Layer> = Array<Layer>()
    public var completeLayers: Bool = false
    //TODO: elements 数据类型是 BaseElement/BaseRenderer，暂定是 BaseElement
    public var elements: Array<BaseElement> = Array<BaseElement>()
    //public var elements: ArrayList<BaseElement> = ArrayList<BaseElement>()
    //var elementsNum: Int64 = 0   //elements 中实际储存的有效的 BaseElement--改为由
    //TODO: 未实现  //var buildItem
    public var globalData: GlobalData = GlobalData()
    
    //TODO: 数据类型未确认，暂定是 BaseElement
    public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()

    //TODO: 在子类 CanvasRendererBase 中具体实现
    public open func buildItem(pos: Int64): Unit {}
    public open func checkPendingElements(): Unit {}
    public open func configAnimation(animData: AnimationData): Unit {}
    public open func updateContentMode(contentMode: String): Unit {}
    public open func updateContainerSize(width: Int64, height: Int64): Unit {}
    //public open func changeColor(color: Array<Int64>): Unit {}
    //public open func changeColor(color: Array<Int64>, endColor: Array<Int64>): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Int64, layer: Int64, index: Int64): Unit {}
    public open func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit {}
    public open func renderFrame(num: Float64, forceRender: Bool): Unit {}
    public open func destroy(): Unit {}
    public open func hide(): Unit {}
    public open func show(): Unit {}

    /**
     * Create a CanvasRendererBase instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(container: CanvasRenderingContext2D) {
        this.canvasContext = container
        this.wrapperInAnimationItem = container

        //调试CVCompElement 中图形绘制渲染未生效，未报错问题。 继承关系中成员变量赋值成功与否。【后续删除】
        //this.globalData = GlobalData(
        //    frameNum: -1.0,
        //    _mdf: false,
        //    renderConfig: RenderConfig(),
        //    currentGlobalAlpha: -1,
        //    canvasContext: container
        //)
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

    public open func createImage(data: Layer): IImageElement { return IImageElement(Layer(), GlobalData()) }
    public open func createComp(data: Layer): ICompElement {
        return ICompElement(Layer(), GlobalData())
    }
    public open func createSolid(data: Layer): ISolidElement { return ISolidElement(Layer(), GlobalData()) }
    public open func createNull(data: Layer): NullElement { return NullElement(Layer(), GlobalData()) }
    public open func createShape(data: Layer): IShapeElement { return IShapeElement(Layer(), GlobalData()) }
    public open func createText(data: Layer): ITextElement { return ITextElement(Layer(), GlobalData()) }

    /**
     * Process layer data and create corresponding Element.
     *
     * @param layer - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @return Type of BaseElement, the element instance.
     */
    public func createItem(layer: Layer): BaseElement {
        if (layer.ty == 2) {
            return this.createImage(layer)
        } else if (layer.ty == 0) {
            return this.createComp(layer)
        } else if (layer.ty == 1) {
            return this.createSolid(layer)
        } else if (layer.ty == 3) {
            return this.createNull(layer)
        } else if (layer.ty == 4) {
            return this.createShape(layer)
        } else if (layer.ty == 5) {
            return this.createText(layer)
        } else if (layer.ty == 6) {
            //TODO: 暂不实现  //return this.createAudio(layer)
            return this.createNull(layer)
        } else if (layer.ty == 13) {
            return this.createCamera(layer)
        } else if (layer.ty == 15) {
            //TODO: 暂不实现  //return this.createFootage(layer)
            return this.createNull(layer)
        } else {
            return this.createNull(layer)
        }
    }

    /**
     * Process layer data and create Camera Element.
     *
     * @param layer - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @return Type of BaseElement, the element instance.
     */
    public func createCamera(data: Layer): BaseElement {
        throw Exception("You\'re using a 3d camera. Try the html renderer.")
    }

    //TODO: 暂不实现  //public func createAudio(data: Layer): BaseElement { return new AudioElement(data, this.globalData, this) }

    //TODO: 暂不实现  //public func createFootage(data: Layer): BaseElement { return new FootageElement(data, this.globalData, this) }

    /**
     * Build all Element.
     */
    public func buildAllItems(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            //在子类 CanvasRendererBase 中具体实现
            this.buildItem(i)
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }

    public func buildAllItemsElement(layersArr: Array<Layer>): Unit {
        let len: Int64 = layersArr.size
        for (i in 0..len) {
            //在子类 CanvasRendererBase 中具体实现
            this.buildItem(i)
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }

    /**
     * Include layers.
     *
     * @param newLayers - Type of Array<Layer>, an instance of the "layers" data that encapsulates the animation.
     */
    public func includeLayers(newLayers: Array<Layer>) {
        this.completeLayers = false
        let len: Int64 = newLayers.size
        var j: Int64 = 0
        let jLen = this.layers.size
        for (i in 0..len) {
            j = 0
            while (j < jLen) {
                //TODO: this.layers[j].id 是 Layer.ind ？？？ -- 暂时用this.layers[j].ind 代替 this.layers[j].id
                if (this.layers[j].ind == newLayers[i].ind) {
                    this.layers[j] = newLayers[i]
                    break
                }
                j += 1
            }
        }
    }

    //TODO: 未实现 ProjectInterface  //public func setProjectInterface(pInterface: ProjectInterface) { this.globalData.projectInterface = pInterface }

    /**
     * Initialize all elements.
     */
    public func initItems() {
        if (!this.globalData.progressiveLoad) {
            this.buildAllItems()
        }
    }

    /**
     * Generate Element Parent.
     *
     * @param element - Type of BaseElement.
     * @param parentName - Type of Int64.
     * @param hierarchy - Type of ArrayList<BaseElement>.
     */
    //TODO： element 数据类型未确认，暂定 BaseElement
    public func buildElementParenting(element: BaseElement, parentName: Int64, hierarchy: ArrayList<BaseElement>): Unit {
        let elements: Array<BaseElement> = this.elements
        let layers: Array<Layer> = this.layers
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ind == parentName) {                   // eslint-disable-line eqeqeq
                //if (!elements[i] || elements[i] == true)
                if (elements.size <= i) {
                    //在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                    this.addPendingElement(element)
                } else {
                    hierarchy.append(elements[i])
                    //TODO[lp]: - HierarchyElement.setAsParent => elements 中保存的是 HierarchyElement ？？？
                    elements[i].setAsParent()
                    if (layers[i].parent != -1) {
                        this.buildElementParenting(element, layers[i].parent, hierarchy)
                    } else {
                        //TODO[lp]: - HierarchyElement.setHierarchy => element 是 HierarchyElement ？？？
                        let bes: ArrayList<HierarchyElement> = ArrayList<HierarchyElement>(hierarchy.size)
                        for(i in 0..hierarchy.size) {
                            //bes[i] = hierarchy[i]
                            bes.append(hierarchy[i])
                        }
                        element.setHierarchy(bes)
                    }
                }
            }
        }
    }

    /**
     * Add pending element.
     *
     * @param element - Type of BaseElement.
     */
    //TODO： element 数据类型未确认，暂定 BaseElement
    public func addPendingElement(element: BaseElement): Unit {
        this.pendingElements.append(element)
    }

    /**
     * Search extra compositions.
     *
     * @param assets - Type of Array<Asset>.
     */
    public func searchExtraCompositions(assets: Array<Asset>): Unit {
        let len: Int64 = assets.size
        for (i in 0..len) {
            //TODO: 暂未在 json 中找到成员变量 xt。
            if (assets[i].xt) {
                //TODO: 当 layer.ty == 101 && isNull == true 时，此 Layer 实际代表的是 Asset。兼容 BaseRenderer.searchExtraCompositions 中 createComp 函数应用。
                let layer: Layer = Layer()
                layer.isAsset = true
                layer.asset = assets[i]
                let comp: ICompElement = this.createComp(layer)
                comp.initExpressions()
                //TODO: GlobalData 中暂未实现 ProjectInterface。
                //this.globalData.projectInterface.registerComposition(comp)
            }
        }
    }

    /**
     * Get Element by id.
     *
     * @param ind - Type of Int64.
     * @return Type of Option<BaseElement>.
     */
    public func getElementById(ind: Int64): Option<BaseElement> {
        let len: Int64 = this.elements.size
        for (i in 0..len) {
            if (this.elements[i].data.ind == ind) {
                return this.elements[i]
            }
        }
        return None
    }

    /**
     * Get Element by path.
     *
     * @param paths - Type of Array<Int64>.
     * @return Type of Option<BaseElement>.
     */
    //TODO: 返回值类型是 element，数据类型未确认，暂定是 BaseElement
    public func getElementByPath(paths: Array<Int64>): Option<BaseElement> {
        if (paths.size <= 0) {
            throw Exception("[BaseRenderer.getElementByPath] the param is empty.")
        }
        let pathValue: Int64 = paths[0]
        let element: BaseElement = this.elements[pathValue]
        if (paths.size == 1) {
            return element
        }
        let path: Array<Int64> = paths.slice(1, paths.size)
        //TODO：未找到 element.getElementByPath，elements 数据类型是 BaseElement/BaseRenderer ？？？
        //TODO：需要后续再确认 this.elements 中的数据类型。
        //return element.getElementByPath(path)
        return element.getElementByPathInt64(path)
    }

    /**
     * Get Element by path.
     *
     * @param paths - Type of Array<String>.
     * @return Type of Option<BaseElement>.
     */
    //TODO: 返回值类型是 element，数据类型未确认，暂定是 BaseElement
    public func getElementByPath(paths: Array<String>): Option<BaseElement> {
        if (paths.size <= 0) {
            throw Exception("[BaseRenderer.getElementByPath] the param is empty!")
        }
        let pathValue: String = paths[0]
        
        var element: Option<BaseElement> = None
        var index: Int64 = 0
        let len: Int64 = this.elements.size
        for (i in 0..len) {
            if (this.elements[i].data.nm == pathValue) {
                index = i
                element = this.elements[i]
                break
            }
        }

        if (paths.size == 1) {
            return element
        }
        let path: Array<String> = paths.slice(1, paths.size)
        //TODO：未找到 element.getElementByPath，elements 数据类型是 BaseElement/BaseRenderer ？？？
        //TODO：需要后续再确认 this.elements 中的数据类型。
        //return this.elements[index].getElementByPath(path)
        return this.elements[index].getElementByPathString(path)
    }

    /**
     * Set global data.
     *
     * @param animData - Type of AnimationData, an instance of the json data that encapsulates the animation.
     * @param fontsContainer - Type of CreateTag.
     */
    //在 canvas 渲染时，fontsContainer是 None。
    public func setupGlobalData(animData: AnimationData, fontsContainer: CreateTag): Unit {
        this.globalData.fontManager = FontManager()
        this.globalData.fontManager.rendererType = this.rendererType

        this.globalData.fontManager.addChars(animData.chars)
        this.globalData.fontManager.addFonts(animData.fonts, fontsContainer)
        //TODO: 未实现 animationItem.getAssetData/getAssetsPath/imagePreloader/audioController
        //TODO：以下 3 个赋值， 移到 [AnimationItem].[setParams] 初始化 Renderer 时。
        //this.globalData.getAssetData = this.animationItem.getAssetData
        //this.globalData.getAssetsPath = this.animationItem.getAssetsPath
        //this.globalData.imageLoader = this.animationItem.imagePreloader
        //TODO：循环依赖。AudioControllerFactory 和 GlobalData 大循环依赖。暂时未实现。
        //this.globalData.audioController = this.animationItem.audioController

        this.globalData.frameId = 0
        this.globalData.frameRate = animData.fr
        this.globalData.nm = animData.nm
        this.globalData.compSize = CompSize(w: Float64(animData.w), h: Float64(animData.h))
    }

}
