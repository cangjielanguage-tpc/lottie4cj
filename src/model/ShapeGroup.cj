/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapeGroup <: ContentModel {

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroupParser
     */
    public let nm: String                    // 0 = name
    public let hd: Bool                      // 1 = hidden
    private let _it: Array<ContentModel>     // 2 = items

    let ty: String = "gr"

    public init(nm: String, it: Array<ContentModel>, hd: Bool) {
        this.nm = nm
        this._it = it
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 0 }
    }

    public prop it: Array<ContentModel> {
        get() { this._it.clone() }
    }

    public func toString(): String {
        return "ShapeGroup[gr]: {\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "hd: ${hd},\n" +
               "it: ${_it}\n}"
    }
}
