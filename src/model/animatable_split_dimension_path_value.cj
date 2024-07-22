/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableSplitDimensionPathValue structure.
 */
package lottie4cj.model

public class AnimatableSplitDimensionPathValue <: ToString {

    private let _k: Array<Keyframe<PointF>>
    private let _x: Array<Keyframe<Float64>>
    private let _y: Array<Keyframe<Float64>>

    /**
     * Create a AnimatableSplitDimensionPathValue instance based on parameters.
     *
     * @param k - Type of Array<Keyframe<PointF>>, the value of k.
     * @param x - Type of Array<Keyframe<Float64>>, the value of x.
     * @param y - Type of Array<Keyframe<Float64>>, the value of y.
     */
    public init(
        k!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        x!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        y!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    ) {
        this._k = k
        this._x = x
        this._y = y
    }

    /**
     * Obtain the k of AnimatableSplitDimensionPathValue.
     */
    public prop k: Array<Keyframe<PointF>> {
        get() { this._k.clone() }
    }

    /**
     * Obtain the x of AnimatableSplitDimensionPathValue.
     */
    public prop x: Array<Keyframe<Float64>> {
        get() { this._x.clone() }
    }

    /**
     * Obtain the y of AnimatableSplitDimensionPathValue.
     */
    public prop y: Array<Keyframe<Float64>> {
        get() { this._y.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableSplitDimensionPathValue: {\n" +
               "k = ${_k}\n" +
               "x = ${_x}\n" +
               "y = ${_y}\n}"
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return _k.size == 0 && _x.size == 0 && _y.size == 0
    }
}
