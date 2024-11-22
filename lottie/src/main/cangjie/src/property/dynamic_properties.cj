/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is DynamicPropertyContainer.
 */
package lottie.property

internal import lottie.global_data.*
internal import lottie.model.*

public open class DynamicPropertyContainer <: ContentModelElement {

    /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
    public var containerType: Int8 = 1
    /*
     * container 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Factory，存在成员变量 container[0]中；一个代表各种 Element，通过操作成员变量 dynamicPropertiesInElem达到效果。
     * 处理方案分为 3 类，参考成员变量 containerType。
     * containerType：1-FrameElement; 2-TransformPropertyFactory; 3-其他Property/DynamicPropertyContainer
     * 间接用 addDynamicPropertyContainer 函数进行分别处理。
     */
    public var container: Array<DynamicPropertyContainer>

    /* comp数据类型：1-Element; 2-Renderer；3-其他 */
    public var compType: Int8 = 0
    /* comp数据类型是 Element，对应的 Element.data.ind */
    public var compDataInd: Int64 = -1
    /*
     * comp 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Element；另一类是 Renderer，用到那个单独处理。
     * 处理方案分为 3 类，参考成员变量 compType。
     * comp数据类型：1-Element; 2-Renderer；3-其他。
     * renderedFrame[0]中函数 => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
     */
    public var getRenderedFrame: Array<(Int64) -> Float64> = empty_Array_Int64_to_Float64

    public var propType: String = ""

    public var elemGlobalData: GlobalData
    public var elemData: Layer

    public var dynamicProperties: ArrayList<DynamicPropertyContainer>
    public var dynamicPropertiesInElem: ArrayList<DynamicPropertyContainer>
    public var _mdf: Bool = false
    public var _isAnimated: Bool = false

    public var isNull: Bool = false

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
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties = ArrayList<DynamicPropertyContainer>()
        this.dynamicPropertiesInElem = dynamicProperties
        this.container = Array<DynamicPropertyContainer>()
    }

    public func getRenderedFrameInElemComp(_compDataInd: Int64): Float64 {
        if (this.compType == 1 && this.getRenderedFrame.size >= 1) {
            return this.getRenderedFrame[0](_compDataInd)
        } else {
            return this.elemGlobalData.renderedFrameInRendered()
        }
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
        /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
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
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties.clear()
        this._mdf = false
        this._isAnimated = false
    }

    public open func getValueAtTime(frameNum: Float64): Array<Float64> { return Array<Float64>()}

}
