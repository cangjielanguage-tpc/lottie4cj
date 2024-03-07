/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class MergePaths <: ContentModel {

    /**
     * 11. "layers"."shapes".{"ty": "mm"} = MergePathsParser
     */
    public let nm: String         // 0 = name
    public let mm: Int64          // 1 = mode
    public let hd: Bool           // 2 = hidden

    let ty: String = "mm"

    public init(nm!: String, mm!: Int64, hd!: Bool){
        this.nm = nm
        this.mm = mm
        this.hd = hd
    }

    public override prop types: Int8 {
        get() { 11 }
    }

    public func toString(): String {
        return "MergePaths[mm]: {\n" +
               "ty = ${ty}\n" +
               "nm = ${nm}\n" +
               "mm = ${mm}\n" +
               "hd = ${hd}\n}"
    }
}
