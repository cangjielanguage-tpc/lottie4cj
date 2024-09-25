/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ProcessedElement.
 */
package lottie4cj.elements


//TODO: 未实现，编译用
public open class ProcessedElement {

    public var elem: ContentModel = ContentModel()
    public var pos: Int64 = 0

    public init(){}
    public init(elem: ContentModel, pos: Int64){
        this.elem = elem
        this.pos = pos
    }

}
