/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public class ShapePath {

    /**
     * 6. "layers"."shapes".{"ty": "sh"} = ShapePathParser
     */
    var nm: String = ""                              //0 = name
    var ind: Int64 = 0                               //1 = ind
    var ks: ArrayList<Keyframe<ShapeData>> = ArrayList<Keyframe<ShapeData>>()    //2 = shape
    var hd: Bool = false                             //3 = hidden

    init(){}
}
