/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class AnimatableTransform {

    /**
     * 5. "layers"."shapes".{"ty": "tr"} = AnimatableTransformParser
     */
    var a: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()                  // 0 = anchorPoint
    var p: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()      // 1 = position
    var s: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()  // 2 = scale

    var r: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()        // 4 = rotation
    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()            // 5 = opacity
    var so: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()       // 6 = startOpacity
    var eo: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()       // 7 = endOpacity
    var sk: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()       // 8 = skew
    var sa: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()       // 9 = skewAngle

     init(){}
}
