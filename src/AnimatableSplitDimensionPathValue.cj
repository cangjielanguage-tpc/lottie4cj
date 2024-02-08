/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class AnimatableSplitDimensionPathValue {

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
}
