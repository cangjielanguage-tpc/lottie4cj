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
    public var container: Array<DynamicPropertyContainer> = Array<DynamicPropertyContainer>()

    //TODO：FrameElement 中编译用。
    public var propType: String = ""

    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    public var elemGlobalData: GlobalData = GlobalData()
    public var elemData: Layer = Layer()

    //TODO: 未确认 dynamicProperties 的数据类型，暂定为 DynamicPropertyContainer
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
    public var dynamicPropertiesInElem: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
    public var _mdf: Bool = false
    public var _isAnimated: Bool = false

    public var isNull: Bool = false

    //public var getValue: (Bool) -> Unit = { flag => return () }

    public init() {
        this.isNull = true
    }

    public init(elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        //super(container)
        //this.container = container

        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicPropertiesInElem = dynamicProperties
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
