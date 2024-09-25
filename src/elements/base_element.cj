/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements

internal import lottie4cj.elements.helpers.*

internal import lottie4cj.inner.*
internal import lottie4cj.utils.*
internal import lottie4cj.utils.helpers.*

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
//TODO: 未完全实现，编译用
public open class BaseElement <: RenderableDOMElement & Equatable<BaseElement> {

    //TODO: maskedElement 在 MaskElement 中编译用。
    public var maskedElement: CreateNS = CreateNS("")
    //TODO: 未找到数据类型，暂定为 String 类型。
    var types: String = ""
    //TODO: style 是一个对象??? 还是一个 HashMap<String, String> ???
    var style: HashMap<String, String> = HashMap<String, String>()
    
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
    
    var layerId: String = ""

    //父[1]类 FrameElement 中有 globalData/dynamicProperties/_isFirstFrame/_mdf
    //父[2]类 HierarchyElement 中有 data
    //父[4]类 RenderableElement 中有 isInRange/hidden/isTransparent
    //父[5]类 RenderableDOMElement 中有 baseElement/layerElement

    /**
     * Create a BaseElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    //设置图层参数
    public func initBaseData(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData
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
    public open func changeColor(color: Array<Int64>): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>): Unit {}

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
        var elem: CreateNS = this.baseElement
        if(this.baseElement.isNull) {
            elem = this.layerElement
        }
        
        elem.styles.put("mix-blend-mode", blendModeValue)
    }

    public func getType(): String {
        //TODO: 未找到数据类型，暂定为 String 类型。
        return this.types
    }

    public open func sourceRectAtTime(): SourceRect {
        return SourceRect()
    }

    //TODO: MaskElement 中编译用。暂未实现 addRenderableComponent。
    public func addRenderableComponent(elem: BaseElement): Unit{}

}
