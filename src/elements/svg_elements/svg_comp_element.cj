/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements.svg_elements

internal import std.collection.*
internal import lottie4cj.utils.*
internal import lottie4cj.model.*
internal import lottie4cj.global_data.*
internal import lottie4cj.utils.helpers.*
internal import lottie4cj.elements.*

//TODO: 未完全实现
public open class SVGCompElement  {

    public var data: Layer

    public var globalData: GlobalData

    
    public init(data: Layer, globalData: GlobalData) {
        this.data = data
        this.globalData = globalData
    }
}