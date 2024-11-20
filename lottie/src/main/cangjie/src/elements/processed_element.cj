/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is ProcessedElement.
 */
package lottie.elements


public open class ProcessedElement {

    public var elem: ContentModel = ContentModel()
    public var pos: Int64 = 0

    public init(){}
    public init(elem: ContentModel, pos: Int64){
        this.elem = elem
        this.pos = pos
    }

}
