/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTransform structure.
 */
//package lottie.shape_items
package lottie.property

//TODO: AnimatableTransformElement 就是命名的 CreateTransformElement
public class AnimatableTransformElement <: ContentModelElement {

    /**
     * 5. "layers"."shapes".{"ty": "tr"} = AnimatableTransform
     */
    public let transform: TransformInElement
    public init(transform: TransformInElement){
        this.transform = transform
        this.ty = "tr"
    }
    //public let _ty: String = "tr"
    //public open prop ty: String {
    //    get() { _ty }
    //}

}

//TODO: TransformInElement 就是命名的 TransformHelpers
public class TransformInElement <: ContentModelElement {

    public var opacity: Float64 = 1.0
    public var _opMdf: Bool = false
    public var key: String = ""
    public var op: PropertyFactory<ArrayKeyframeInt64, Int64>      //AnimatableTransform.o // 5 = opacity        // k: Array<Keyframe<Int64>>
    public var mProps: TransformProperty                           //AnimatableTransform

    public init(opacity!: Float64 = 1.0,
                _opMdf!: Bool = false,
                key!: String = "",
                op!: PropertyFactory<ArrayKeyframeInt64, Int64>,
                mProps!: TransformProperty
    ){
        this.opacity = opacity
        this._opMdf = _opMdf
        this.key = key
        this.op = op
        this.mProps = mProps
    }

}


