/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is SVGCompElement.
 */
package lottie4cj.elements.svg_elements

internal import std.collection.*
internal import lottie4cj.utils.*
internal import lottie4cj.model.*
internal import lottie4cj.global_data.*
internal import lottie4cj.utils.helpers.*

//TODO: 未完全实现
public open class SVGCompElement  <: ICompElement {

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.layers = data.layers;
        this.supports3d = true;
        this.completeLayers = false;
        if (this.layers.size >0) {
            this.elements = Array<BaseElement>(this.layers.size,repeat: BaseElement(data, globalData))
        }else {
            this.elements = Array<BaseElement>()
        }
        //TODO: 未实现,初拟定了一个数据类型TM
        this.tm  = TM()
    }
}