/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableSplitDimensionPathValue <: ToString {

    var k: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
    var x: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
    var y: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

    public init(
        k!: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>(),
        x!: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>(),
        y!: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
    ) {
        this.k = k
        this.x = x
        this.y = y
    }

    public func toString(): String {
        return "AnimatableSplitDimensionPathValue: { \n" +
               "k = ${k} \n" +
               "x = ${x} \n" +
               "y = ${y} \n}"
    }

}
