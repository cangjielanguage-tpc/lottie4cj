/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class AnimatableSplitDimensionPathValue <: ToString {

    private let _k: Array<Keyframe<PointF>>
    private let _x: Array<Keyframe<Float64>>
    private let _y: Array<Keyframe<Float64>>

    public init(
        k!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        x!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        y!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    ) {
        this._k = k
        this._x = x
        this._y = y
    }

    public prop k: Array<Keyframe<PointF>> {
        get() { this._k.clone() }
    }

    public prop x: Array<Keyframe<Float64>> {
        get() { this._x.clone() }
    }

    public prop y: Array<Keyframe<Float64>> {
        get() { this._y.clone() }
    }

    public func toString(): String {
        return "AnimatableSplitDimensionPathValue: {\n" +
               "k = ${_k}\n" +
               "x = ${_x}\n" +
               "y = ${_y}\n}"
    }

}
