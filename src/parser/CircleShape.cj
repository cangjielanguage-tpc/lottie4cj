/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class CircleShape <: ContentModel {

    /**
     * 7. "layers"."shapes".{"ty": "el"} = CircleShapeParser
     */
    var nm: String = ""                                // 0 = name
    var p: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()    // 1 = position
    var s: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()                // 2 = size
    var hd: Bool = false                               // 3 = hidden
    var d: Int64 = 0                                   // 4 = reversed
    
    let ty: String = "el"

    init(){}

    public override prop types: Int8 {
        get() { 7 }
    }

    public func toString(): String {
        return "CircleShape[el]: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "p = ${p},\n" +
               "s = ${s},\n" +
               "hd = ${hd},\n" +
               "d = ${d} \n}"
    }
}
