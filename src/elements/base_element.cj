/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package elements


//TODO: 未实现，编译用
public open class BaseElement <: Equatable<BaseElement> {

    public var pos: Int64 = 0
    public var _mdf: Bool = false
    //TODO: 未确认具体数据类型
    public var elem: String = ""

    public init(){}
    public operator func ==(that: BaseElement): Bool { return true }
    public operator func !=(that: BaseElement): Bool { return !(this == that) }
    public open func prepareFrame(num: Float64): Unit {}
    public open func renderFrame(): Unit {}
    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>): Unit {}
    public open func changeColor(color: Array<Int64>): Unit {}
    public open func destroy(): Unit {}

}
