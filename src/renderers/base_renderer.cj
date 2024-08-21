/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a BaseRenderer.
 */
package lottie4cj.renderers

internal import lottie4cj.model.*
internal import lottie4cj.elements.*
internal import lottie4cj.animation.*
internal import lottie4cj.global_data.*
internal import lottie4cj.bezier.*
internal import lottie4cj.utils.*
internal import lottie4cj.utils.helpers.*

internal import std.collection.*

public open class BaseRenderer {

    public var layers: Array<Layer> = Array<Layer>()
    public var completeLayers: Bool = true
    //TODO: elements 数据类型是 BaseElement/BaseRenderer，暂定是 BaseElement
    public var elements: Array<BaseElement> = Array<BaseElement>()
    //TODO: 未实现  //var buildItem
    public var globalData: GlobalData = GlobalData()
    
    //TODO: 数据类型未确认，暂定是 BaseElement
    public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()
    
    //TODO: 在子类 CanvasRendererBase 中具体实现
    public open func buildItem(pos: Int64): Unit {}
    public open func checkPendingElements(): Unit {}

    /**
     * Check layers.
     *
     * @param num - Type of Float64.
     */
    public func checkLayers(num: Float64): Unit {
        var len: Int64 = this.layers.size
        var data: Layer = Layer()
        this.completeLayers = true

        for(i in ((len - 1)..=0 : -1)) {
            //如果当层无 element，代表该层 layer 未处理。
            if (this.elements.size < i - 1) {
                data = this.layers[i]
                if ((data.ip - data.st) <= (num - this.layers[i].st) && (data.op - data.st) > (num - this.layers[i].st)) {
                    //TODO: 在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                }
            }

            if (this.elements.size <= i) {
                this.completeLayers = false
            }
        }
        //TODO: 在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }
    
    //TODO: 编译用，拆解多继承调用
    /*
    //TODO: 未实现 CvImageElement 
    //public func createImage(data: Layer): CvImageElement
    public func createComp(data: Layer): CvCompElement
    public func createSolid(data: Layer): CvSolidElement
    public func createNull(data: Layer): NullElement
    public func createShape(data: Layer): CvShapeData
    //TODO: 未实现 CvTextElement 
    //public func createText(data: Layer): CvTextElement
    */
    
    //TODO: 未实现 BaseElement 子类 CvImageElement/CvCompElement/CvSolidElement/CvShapeData/CvTextElement
    public open func createImage(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }
    public open func createComp(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }
    public open func createSolid(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }
    public open func createNull(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }
    public open func createShape(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }
    public open func createText(data: Layer): BaseElement { return BaseElement(Layer(), GlobalData()) }

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
            //TODO: 在子类 CanvasRendererBase 中具体实现
            this.buildItem(i)
        }
        //TODO: 在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }

    /**
     * Include layers.
     *
     * @param newLayers - Type of Array<Layer>, an instance of the "layers" data that encapsulates the animation.
     */
    public func includeLayers(newLayers: Array<Layer>): Unit {
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
    public func initItems(): Unit {
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
 
                if (elements.size <= i) {
                    //TODO: 在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                    this.addPendingElement(element)
                } else {
                    hierarchy.append(elements[i])
                    //TODO: 未确认，未实现   //elements[i].setAsParent()
                    if (layers[i].parent != -1) {
                        this.buildElementParenting(element, layers[i].parent, hierarchy)
                    } else {
                        //TODO: 未确认，未实现   //element.setHierarchy(hierarchy)
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
            if (assets[i].xt) {
                //TODO：this.createComp传入的参数是layer，此处是assets。要开发同名函数？？？
                /*
                var comp: CvCompElement = this.createComp(assets[i]) 
                comp.initExpressions() 
                this.globalData.projectInterface.registerComposition(comp) 
                */
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
        if (paths.size <= 0) { throw Exception("[BaseRenderer.getElementByPath] the param is empty.") }
        var pathValue = paths[0]
        var path: Array<Int64> = paths.slice(1, paths.size)
        var element = this.elements[pathValue]
        if (path.size == 0) {
            return element
        }
        //TODO：未找到 element.getElementByPath，elements 数据类型是 BaseElement/BaseRenderer ？？？   //return element.getElementByPath(path)
        return None
    }

    /**
     * Get Element by path.
     *
     * @param paths - Type of Array<String>.
     * @return Type of Option<BaseElement>.
     */
    //TODO: 返回值类型是 element，数据类型未确认，暂定是 BaseElement
    public func getElementByPath(paths: Array<String>): Option<BaseElement> {
        if (paths.size <= 0) { throw Exception("[BaseRenderer.getElementByPath] the param is empty.") }
        var pathValue = paths[0]
        var path: Array<String> = paths.slice(1, paths.size)
        var element: Option<BaseElement> = None

        let len: Int64 = this.elements.size
        for (i in 0..len) {
            if (this.elements[i].data.nm == pathValue) {
                element = this.elements[i]
                break
            }
        }

        if (path.size == 0) {
            return element
        }
        //TODO：未找到 element.getElementByPath，elements 数据类型是 BaseElement/BaseRenderer ？？？  //return element.getElementByPath(path)
        return None
    }

    /**
     * Set global data.
     *
     * @param animData - Type of AnimationData, an instance of the json data that encapsulates the animation.
     * @param fontsContainer - Type of CreateTag.
     */
    public func setupGlobalData(animData: AnimationData, fontsContainer: CreateTag): Unit {
        this.globalData.fontManager = FontManager()
        //TODO: 未实现 fontManager.addChars/addFonts
        //TODO: 未实现 animationItem.getAssetData/getAssetsPath/imagePreloader/audioController
        /*
        this.globalData.fontManager.addChars(animData.chars)
        this.globalData.fontManager.addFonts(animData.fonts, fontsContainer)
        this.globalData.getAssetData = this.animationItem.getAssetData
        this.globalData.getAssetsPath = this.animationItem.getAssetsPath
        this.globalData.imageLoader = this.animationItem.imagePreloader
        this.globalData.audioController = this.animationItem.audioController
        */
        this.globalData.frameId = 0
        this.globalData.frameRate = animData.fr
        this.globalData.nm = animData.nm
        this.globalData.compSize = CompSize(w: Float64(animData.w), h: Float64(animData.h))
    }

}
