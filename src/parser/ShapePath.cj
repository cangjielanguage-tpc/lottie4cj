/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapePath <: ContentModel {

    /**
     * 6. "layers"."shapes".{"ty": "sh"} = ShapePathParser
     */
    var nm: String = ""                             //0 = name
    var ind: Int64 = 0                              //1 = ind
    var ks: ArrayList<Keyframe<ShapeData>> = ArrayList<Keyframe<ShapeData>>()    //2 = shape
    var hd: Bool = false                            //3 = hidden

    let ty: String = "sh"

    init(){}

    public override prop types: Int8 {
        get() { 6 }
    }

    public func toString(): String {
        return "ShapePath[sh]: { \n" +
               "ind: ${ind},\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "ks: ${ks},\n" +
               "hd: ${hd} \n}"
    }
}
