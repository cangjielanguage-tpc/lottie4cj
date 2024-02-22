/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapeGroup <: ContentModel {

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroupParser
     */
    var nm: String = ""                                          // 0 = name
    var hd: Bool = false                                         // 1 = hidden
    var it: ArrayList<ContentModel> = ArrayList<ContentModel>()  // 2 = items

    let ty: String = "gr"

    init(){}
    public init(nm: String, it: ArrayList<ContentModel>, hd: Bool) {
        this.nm = nm
        this.it = it
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 0 }
    }

    public func toString(): String {
        return "ShapeGroup[gr]: { \n" +
               "ty: ${ty}, \n" +
               "nm: ${nm}, \n" +
               "hd: ${hd}, \n" +
               "it: ${it} \n}"
    }
}
