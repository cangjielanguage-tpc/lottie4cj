/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a BaseRenderer.
 */
package lottie.renderers

internal import std.collection.*

internal import lottie.model.*
internal import lottie.elements.*
//import lottie.elements.helpers.*
internal import lottie.global_data.*
internal import lottie.bezier.*
internal import lottie.utils.helpers.*
import lottie.utils.*


public type CreateTag = CreateNS

public open class BaseRenderer {

    /*
     * 解构以下 AnimationItem 和 Renderer。
     * this.animationItem.wrapper
     * this.animationItem.container
     * this.animationItem._isFirstFrame
     * this.animationItem.contentMode
     */
    public var wrapperInAnimationItem: LottieCanvasRenderingContext2D

    /*
     * 数据类型推测路线：
     * this.canvasContext = this.renderConfig.context
     * this.canvasContext = this.animationItem.wrapper
     * [AnimationItem] this.wrapper = params.wrapper || params.container ( params <=> loadAnimation(params) )
     *   =>  CanvasRenderingContext2D = this.canvasContext = this.renderConfig.context
     */
    public var canvasContext: LottieCanvasRenderingContext2D

    public var _isFirstFrameInAnimationItem: () -> Float64 = { => 0.0 }
    public var contentModeInAnimationItem: () -> String = { => "" }

    public var rendererType: String = ""


    public var layers: Array<Layer> = Array<Layer>()
    public var completeLayers: Bool = false

    public var elements: Array<BaseElement> = Array<BaseElement>()
    public var globalData: GlobalData = empty_globalData

    public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()

    public open func buildItem(pos: Int64): Unit {}
    public open func checkPendingElements(): Unit {}
    public open func configAnimation(animData: AnimationData): Unit {}
    public open func updateContentMode(contentMode: String): Unit {}
    public open func updateContainerSize(width: Int64, height: Int64): Unit {}

    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Int64, layer: Int64, index: Int64): Unit {}
    public open func changeColor(color: Array<Int64>): Unit {}
    public open func renderFrame(num: Float64, forceRender: Bool): Unit {}
    public open func destroy(): Unit {}
    public open func hide(): Unit {}
    public open func show(): Unit {}

    /**
     * Create a CanvasRendererBase instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(container: LottieCanvasRenderingContext2D) {
        this.canvasContext = (container)
        this.wrapperInAnimationItem = container
    }

    public func checkLayers(num: Float64): Unit {
        var len: Int64 = this.layers.size
        var data: Layer = empty_layer
        this.completeLayers = true

        for(i in ((len - 1)..=0 : -1)) {
            /* 如果当层无 element，代表该层 layer 未处理。 */
            if (this.elements[i].isNull) {
                data = this.layers[i]
                if ((data.ip - data.st) <= (num - this.layers[i].st) && (data.op - data.st) > (num - this.layers[i].st)) {
                    this.buildItem(i)
                }
            }
            
            if (this.elements[i].isNull) {
                this.completeLayers = false
            }
        }

        this.checkPendingElements()
    }

    public open func createImage(data: Layer): IImageElement { return IImageElement(empty_layer, empty_globalData) }
    public open func createComp(data: Layer): ICompElement {
        return ICompElement(empty_layer, empty_globalData)
    }
    public open func createSolid(data: Layer): ISolidElement { return ISolidElement(empty_layer, empty_globalData) }
    public open func createNull(data: Layer): NullElement { return NullElement(empty_layer, empty_globalData) }
    public open func createShape(data: Layer): IShapeElement { return IShapeElement(empty_layer, empty_globalData) }
    public open func createText(data: Layer): ITextElement { return ITextElement(empty_layer, empty_globalData) }

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
            /* 暂不实现  --return this.createAudio(layer) */
            return this.createNull(layer)
        } else if (layer.ty == 13) {
            return this.createCamera(layer)
        } else if (layer.ty == 15) {
            /* 暂不实现  --return this.createFootage(layer) */
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

    /**
     * Build all Element.
     */
    public func buildAllItems(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            this.buildItem(i)
        }
        this.checkPendingElements()
    }

    public func buildAllItemsElement(layersArr: Array<Layer>): Unit {
        let len: Int64 = layersArr.size
        for (i in 0..len) {
            this.buildItem(i)
        }
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
                /* this.layers[j].id 是 Layer.ind ？？？ -- 暂时用this.layers[j].ind 代替 this.layers[j].id */
                if (this.layers[j].ind == newLayers[i].ind) {
                    this.layers[j] = newLayers[i]
                    break
                }
                j += 1
            }
        }
    }

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
    public func buildElementParenting(element: BaseElement, parentName: Int64, hierarchy: ArrayList<BaseElement>): Unit {
        let elements: Array<BaseElement> = this.elements
        let layers: Array<Layer> = this.layers
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ind == parentName) {                   /* eslint-disable-line eqeqeq */
                if (elements.size <= i || elements[i].isNull) {
                    this.buildItem(i)
                    this.addPendingElement(element)
                } else {
                    hierarchy.append(elements[i])
                    elements[i].setAsParent()
                    if (layers[i].parent != -1) {
                        this.buildElementParenting(element, layers[i].parent, hierarchy)
                    } else {
                        let bes: ArrayList<HierarchyElement> = ArrayList<HierarchyElement>(hierarchy.size)
                        for(i in 0..hierarchy.size) {
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
            if (assets[i].xt) {
                let layer: Layer = Layer()
                layer.isAsset = true
                layer.asset = assets[i]
                let comp: ICompElement = this.createComp(layer)
                comp.initExpressions()
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
        return element.getElementByPathInt64(path)
    }

    /**
     * Get Element by path.
     *
     * @param paths - Type of Array<String>.
     * @return Type of Option<BaseElement>.
     */
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
        return this.elements[index].getElementByPathString(path)
    }

    /**
     * Set global data.
     *
     * @param animData - Type of AnimationData, an instance of the json data that encapsulates the animation.
     * @param fontsContainer - Type of CreateTag.
     */
    public func setupGlobalData(animData: AnimationData, fontsContainer: CreateTag): Unit {
        this.globalData.fontManager = FontManager()
        this.globalData.fontManager.rendererType = this.rendererType

        this.globalData.fontManager.addChars(animData.chars)
        this.globalData.fontManager.addFonts(animData.fonts, fontsContainer)

        this.globalData.frameId = 0
        this.globalData.frameRate = animData.fr
        this.globalData.nm = animData.nm
        this.globalData.compSize = CompSize(w: Float64(animData.w), h: Float64(animData.h))
    }

}
