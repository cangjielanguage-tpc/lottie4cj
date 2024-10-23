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

    //TODO：FrameElement 中编译用。
    public var propType: String = ""

    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    public var elemGlobalData: GlobalData = GlobalData()
    public var elemData: Layer = Layer()

    //TODO: 未确认 dynamicProperties 的数据类型，暂定为 DynamicPropertyContainer
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
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
        this.dynamicProperties = dynamicProperties
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
        //this.container.addDynamicProperty(this)
        this._isAnimated = true
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
