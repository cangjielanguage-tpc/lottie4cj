/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeGroup structure.
 */
package lottie.property

public class ShapeGroupElement <: ContentModelElement {

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroup
     */
    public var it: ArrayList<ContentModelElement> = ArrayList<ContentModelElement>()
    public var prevViewData: ArrayList<ContentModelElement> = ArrayList<ContentModelElement>()

    public init(){
        this.ty = "gr"
    }

}
