/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeGroup structure.
 */
//package lottie.shape_items
package lottie.property

//TODO: ShapeGroupElement 就是命名的 GroupElement <: CreatSearchElement
public class ShapeGroupElement <: ContentModelElement {

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroup
     */
    public var it: Array<ContentModelElement> = Array<ContentModelElement>()
    public var prevViewData: Array<ContentModelElement> = Array<ContentModelElement>()

    //public let ty: String = "gr"
    
    public init(){
        this.ty = "gr"
    }

}
