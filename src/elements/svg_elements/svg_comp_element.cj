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
        this.data = data
        this.globalData = globalData
    }
}