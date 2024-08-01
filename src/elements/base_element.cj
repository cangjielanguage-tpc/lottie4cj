/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements

internal import lottie4cj.inner.*
internal import lottie4cj.utils.*
internal import lottie4cj.utils.helpers.*

//TODO: 未完全实现
public open class BaseElement <: Equatable<BaseElement> {

    //TODO: 此处的 types == type。因为 type 是关键字，只能改为 types。
    //TODO: 未找到数据类型    //var types: Any
    //TODO: style 是一个对象??? 还是一个 HashMap<String, String> ???
    var style: HashMap<String, String> = HashMap<String, String>()

    //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
    var baseElement: CreateNS = CreateNS("")
    var layerElement: CreateNS = CreateNS("")
    
    //TODO: 未完全确认 this.maskManager    //var maskManager: MaskManagerInterface
    //TODO: 未完全实现 EffectsManager   //var effectsManager: EffectsManager
    //TODO: 未实现 this.dynamicProperties    //var dynamicProperties

    //TODO: 未完全确认数据类型 //var layers:     //CompExpressionInterface中用到
    //TODO: 未完全确认数据类型 //var elements:   //CompExpressionInterface中用到

    //TODO: 未完全实现 LayerExpressionInterface //var layerInterface: LayerExpressionInterface
    //TODO: 未完全实现 CompExpressionInterface  //var compInterface: CompExpressionInterface

    var shapesData: Array<ContentModel> = Array<ContentModel>()
    //TODO: 未确认。itemsData 是 shapesData 初加工后的数据？？？
    var itemsData: Array<ContentModel> = Array<ContentModel>()
    
    public var pos: Int64 = 0
    public var _mdf: Bool = false
    var layerId: String = ""

    //TODO:  未确认数据类型，暂定 Bool
    public var isInRange: Bool = false

    public var data: Layer
    public var globalData: GlobalData
    //TODO: 未完全实现 RendererBase / CanvasRendererBase        //public var comp: RendererBase

    /**
     * Create a BaseElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        this.globalData = globalData
        this.data = data
        this.layerId = CreateElementID.createID()

        //缺少此属性的旧动画的拉伸因子。
        if (this.data.sr == 0.0) {
            this.data.sr = 1.0
        }

        //TODO: 未完全实现 EffectsManager 效果管理器
        //TODO: 未实现 this.dynamicProperties   //this.effectsManager = EffectsManager(this.data, this, this.dynamicProperties)
    }

    //TODO: 未实现，编译用
    public operator func ==(that: BaseElement): Bool { return true }
    public operator func !=(that: BaseElement): Bool { return !(this == that) }
    public open func prepareFrame(num: Float64): Unit {}
    public open func renderFrame(): Unit {}
    public open func changeColor(color: Array<Int64>): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {}
    public open func destroy(): Unit {}

    /**
     * Check mask data.
     *
     * @return Type of Bool, return the result of check mask data.
     */
    public func checkMasks(): Bool {
        if (!this.data.hasMask) {
            return false
        }
        let len: Int64 = this.data.masksProperties.size
        for (i in 0..len) {
            if ((this.data.masksProperties[i].mode != "n" && this.data.masksProperties[i].cl)) {
                return true
            }
        }
        return false
    }
    
    //TODO: 未实现 initExpressions
    public func initExpressions(): Unit { }

    /**
     * set blend mode.
     */
    public open func setBlendMode(): Unit {
        let blendModeValue: String = BlendModes.getBlendMode(this.data.bm)

        //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
        var elem = this.baseElement
        if(this.baseElement.isNull) {
            elem = this.layerElement
        }
        
        elem.styles.put("mix-blend-mode", blendModeValue)
    }

    public func getType() {
        //TODO: 未找到数据类型   //return this.types
    }

    //TODO: 返回值类型，需要和子类中的核对
    public open func sourceRectAtTime(): Any {}

}
