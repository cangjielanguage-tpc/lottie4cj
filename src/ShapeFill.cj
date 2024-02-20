/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class ShapeFill {

    /**
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFillParser
     */
    var nm: String = ""                                                                 // 0 = name
    var c: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()  // 1
    var o: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()                    // 2 = opacity
    var fillEnabled: Bool = false                                                       // 3 = fillEnabled
    var r: Int64 = 0                                                                    // 4 = fillTypeInt
    var hd: Bool = false                                                                // 5 = hidden

    init(){}
}