/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class Repeater {

    /**
     * 11. "layers"."shapes".{"ty": "rp"} = RepeaterParser
     */
    var nm: String = ""                                                          // 0 = name
    var c: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()         // 1 = copies
    var o: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()         // 2 = offset
    //var transform: ContentModel = ContentModel() //AnimatableTransform
    var tr: AnimatableTransform = AnimatableTransform()                          // 3 = transform
    var hd: Bool = false                                                         // 4 = hidden

     init(){}
}
