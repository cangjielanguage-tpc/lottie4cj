/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is DynamicPropertyContainer.
 */
//package lottie.utils.helpers
package lottie.property

internal import lottie.global_data.*
internal import lottie.model.*


//TODO： DynamicPropertyContainer 是各个 property 的父类？？？
public open class DynamicPropertyContainer <: ContentModelElement {

    //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property/DynamicPropertyContainer
    public var containerType: Int8 = 1
    //public var containerInFP: Array<DynamicPropertyContainer> = Array<DynamicPropertyContainer>()
    /*
     * TODO: container 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Factory，存在成员变量 container[0]中；一个代表各种 Element，通过操作成员变量 dynamicPropertiesInElem达到效果。
     * 处理方案分为 3 类，参考成员变量 containerType。
     * containerType：1-FrameElement; 2-TransformPropertyFactory; 3-其他Property/DynamicPropertyContainer
     * 间接用 addDynamicPropertyContainer 函数进行分别处理。
     */
    public var container: Array<DynamicPropertyContainer>

    //comp数据类型：1-Element; 2-Renderer；3-其他
    public var compType: Int8 = 0
    /*
     * TODO: comp 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Element；另一类是 Renderer，用到那个单独处理。
     * 处理方案分为 3 类，参考成员变量 compType。
     * comp数据类型：1-Element; 2-Renderer；3-其他。
     * renderedFrame[0]中函数 => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
     */
    public var getRenderedFrame: Array<() -> Float64> = empty_Array_unit_to_Float64

    //TODO：FrameElement 中编译用。
    public var propType: String = ""

    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    public var elemGlobalData: GlobalData
    public var elemData: Layer

    //TODO: 未确认 dynamicProperties 的数据类型，暂定为 DynamicPropertyContainer
    public var dynamicProperties: ArrayList<DynamicPropertyContainer>
    public var dynamicPropertiesInElem: ArrayList<DynamicPropertyContainer>
    public var _mdf: Bool = false
    public var _isAnimated: Bool = false

    public var isNull: Bool = false

    //public var getValue: (Bool) -> Unit = { flag => return () }

    public init() {
        this.isNull = true

        this.elemGlobalData = empty_globalData
        this.elemData = empty_layer
        let dps: ArrayList<DynamicPropertyContainer> = empty_dynamicProperties
        this.dynamicProperties = dps
        this.dynamicPropertiesInElem = dps
        this.container = empty_Array_dp
    }

    public init(elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        //super(container)
        //this.container = container

        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties = ArrayList<DynamicPropertyContainer>()
        this.dynamicPropertiesInElem = dynamicProperties
        this.container = Array<DynamicPropertyContainer>()
    }

    public func getRenderedFrameInElemComp(): Float64 {
        if (this.compType == 1 && this.getRenderedFrame.size >= 1) {
            //Hilog.error(0, "--29--", "[getRenderedFrameInElemComp]--[1]--------------------------------")
            //return this.getRenderedFrame[0]()

            let num = this.getRenderedFrame[0]()
            //Hilog.error(0, "--29--", "[getRenderedFrameInElemComp]--[1]--------------------------------num = ${num}")
            return num
        } else {
            //Hilog.error(0, "--29--", "[getRenderedFrameInElemComp]--[2]--------------------------------")
            //return this.elemGlobalData.renderedFrameInRendered()

            let num = this.elemGlobalData.renderedFrameInRendered()
            //Hilog.error(0, "--29--", "[getRenderedFrameInElemComp]--[2]--------------------------------num = ${num}")
            return num
        }
    }

    //TODO: 改为函数类型的成员变量？？？
    public open func getValue(): Unit {}
    public open func getValue(flag: Bool): Unit {}

    public open func addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
        //if (this.dynamicProperties.indexOf(dpc) === -1)
        for (i in 0..dynamicProperties.size) {
            if (refEq(dpc, dynamicProperties[i])) {
                return
            }
        }
        this.dynamicProperties.append(dpc)
        //TODO: 循环调用
        //TODO： BaseElement 中暂时没有实现 addDynamicProperty 函数。
        //TODO：此函数是将TextProperty存入到 ITextElement.dynamicProperties 中。
        //TODO: 【处理方案】传入 ITextElement.dynamicProperties 而非 elem 可以吗？
        //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property/DynamicPropertyContainer
        if (containerType == 2 && this.container.size == 1) {
            this.container[0].addDynamicProperty(this)
        } else if (containerType == 1) {
            this.addDynamicPropertyInElem(this)
        } else if (containerType == 3 && this.container.size == 1){
            this.container[0].addDynamicProperty(this)
        }
        this._isAnimated = true
    }

    public open func addDynamicPropertyInElem(props: DynamicPropertyContainer): Unit {
        for (i in 0..this.dynamicPropertiesInElem.size) {
            if (refEq(props, this.dynamicPropertiesInElem[i])) {
                return
            }
        }
        this.dynamicPropertiesInElem.append(props)
    }

    public func iterateDynamicProperties(): Unit {
        this._mdf = false
        let len: Int64 = this.dynamicProperties.size
        for (i in 0..len) {
            this.dynamicProperties[i].getValue()
            if (this.dynamicProperties[i]._mdf) {
                this._mdf = true
            }
        }
    }

    /* container  =>  ITextElement */
    public func initDynamicPropertyContainer(elemGlobalData: GlobalData, elemData: Layer): Unit {
        //this.container = container
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties.clear()
        this._mdf = false
        this._isAnimated = false
    }

//--------------------------------------------------------------------------------
    //TODO: expression 中扩展的函数.
    //public var getValueAtTime: (Float64) -> Array<Float64> = { n => return [n] }
    public open func getValueAtTime(frameNum: Float64): Array<Float64> { return Array<Float64>()}








//------------------------------------------------------------------------------------------------------------------------------


}
