/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements.html_elements

internal import std.collection.*
//TODO: 未完全实现
public open class HBaseElement <: Equatable<HBaseElement>{

    public operator func ==(that: HBaseElement): Bool { return true }

    public operator func !=(that: HBaseElement): Bool { return !(this == that) }
}
