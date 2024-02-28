/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class MergePaths <: ContentModel {

    /**
     * 11. "layers"."shapes".{"ty": "mm"} = MergePathsParser
     */
    var nm: String = ""         // 0 = name
    var mm: Int64 = 0           // 1 = mode
    var hd: Bool = false        // 2 = hidden

    let ty: String = "mm"

    init(){}

    public override prop types: Int8 {
        get() { 11 }
    }

    public func toString(): String {
        return "MergePaths[mm]: { \n" +
               "ty = ${ty} \n" +
               "nm = ${nm} \n" +
               "mm = ${mm} \n" +
               "hd = ${hd} \n}"
    }
}
