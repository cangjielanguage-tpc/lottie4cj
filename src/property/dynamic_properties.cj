/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is DynamicPropertyContainer.
 */
package lottie4cj.property

internal import lottie4cj.elements.*


//TODO： DynamicPropertyContainer 是各个 property 的父类？？？
public open class DynamicPropertyContainer {

    public var container: BaseElement
    //TODO: 未确认 dynamicProperties 的数据类型，暂定为 DynamicPropertyContainer
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
    public var _mdf: Bool = false
    public var _isAnimated: Bool = false

    public init(container: BaseElement) {
        this.container = container
    }

    public open func getValue(): Unit {}
    public open func getValue(flag: Bool): Unit {}

    public func addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
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
    func initDynamicPropertyContainer(container: BaseElement): Unit {
        this.container = container
        this.dynamicProperties.clear()
        this._mdf = false
        this._isAnimated = false
    }
}
