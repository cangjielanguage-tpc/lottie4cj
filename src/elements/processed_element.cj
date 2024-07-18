/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ProcessedElement.
 */
package lottie4cj.elements

public open class ProcessedElement {

    //TODO: 未确认数据类型，暂定BaseElement
    public var elem: BaseElement
    public var pos: Int64 = 0

    public init(elem: BaseElement, pos: Int64){
        this.elem = elem
        this.pos = pos
    }

}
