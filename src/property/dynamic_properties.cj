/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is DynamicPropertyContainer.
 */
package lottie4cj.property

internal import lottie4cj.global_data.*
internal import lottie4cj.model.*

//TODO： DynamicPropertyContainer 是各个 property 的父类？？？
public open class DynamicPropertyContainer <: ElementData2 {

    //TODO：FrameElement 中编译用。
    public var propType: String = ""

    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。
    public var elemGlobalData: GlobalData = GlobalData()
    public var elemData: Layer = Layer()

    //TODO: 未确认 dynamicProperties 的数据类型，暂定为 DynamicPropertyContainer
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
    public var _mdf: Bool = false
    public var _isAnimated: Bool = false

    public init() {}

    public init(elemGlobalData: GlobalData, elemData: Layer) {
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
    }

    public open func getValue(): Unit {}
    public open func getValue(flag: Bool): Unit {}

    public open func addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
        for (i in 0..dynamicProperties.size) {
            if (refEq(dpc, dynamicProperties[i])) {
                return
            }
        }
        this.dynamicProperties.append(dpc)
        //TODO： BaseElement 中暂时没有实现 addDynamicProperty 函数。  //this.container.addDynamicProperty(this)
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
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties.clear()
        this._mdf = false
        this._isAnimated = false
    }
}
