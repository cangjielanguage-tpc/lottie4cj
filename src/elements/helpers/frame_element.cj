/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * Handles element's layer frame update.   处理元素的层框架更新。
 * Checks layer in point and out point     检查层入点和出点
 */
package lottie4cj.elements.helpers

internal import std.collection.*

internal import lottie4cj.global_data.*
internal import lottie4cj.property.*

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
public open class FrameElement {

    /* 渲染inpoint时设置为true */
    public var _isFirstFrame: Bool = false

    //TODO: 此处的 dynamicProperties 中数据类型是哪种？  TextProperty  /  PropertyFactory，暂定是 PropertyFactory。
    /* 动画特性列表 */
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>(24)

    /* 如果层在当前刻度中已修改，则为真 */
    public var _mdf: Bool = false

    public var _isParent: Bool = false
    public var globalData: GlobalData = GlobalData()

    /**
     * 初始化与帧相关的属性。
     */
    public func initFrame(): Unit {
        //渲染inpoint时设置为true
        this._isFirstFrame = false
        //动画特性列表
        this.dynamicProperties = ArrayList<DynamicPropertyContainer>(24)
        //如果层在当前刻度中已修改，则为真
        this._mdf = false
    }
    /**
     * 计算所有动态值
     *
     * @param num - 层时间中的当前帧数
     * @param isVisible - 如果层当前在范围内
     */
    public func prepareProperties(num: Int64, isVisible: Bool): Unit {
        let len: Int64 = this.dynamicProperties.size
        for (i in 0..len) {
            if (isVisible || (this._isParent && this.dynamicProperties[i].propType == "transform")) {
                this.dynamicProperties[i].getValue()
                if (this.dynamicProperties[i]._mdf) {
                    this.globalData._mdf = true
                    this._mdf = true
                }
            }
        }
    }

    /**
     * Add dynamic attributes.
     *
     * @param props - Type of DynamicPropertyContainer.
     * @return Type of Font, result value.
     */
    public func addDynamicProperty(props: DynamicPropertyContainer): Unit {
        for (i in 0..this.dynamicProperties.size) {
            if (refEq(props, this.dynamicProperties[i])) {
                return
            }
        }
        this.dynamicProperties.append(props)
    }

}
