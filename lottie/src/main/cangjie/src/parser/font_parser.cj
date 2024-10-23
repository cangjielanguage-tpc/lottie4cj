/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.parser

class FontParser {
    
    /* "fonts"."list"[{.}] */
    private static let NAMES: Array<String> = [
        "fFamily", // 0 = family
        "fName",   // 1 = name
        "fStyle",  // 2 = style
        "ascent",  // 3 = ascent

        "fOrigin", // 4 = "fOrigin"
        "origin",  // 5 = "origin"
        "fPath",   // 6 = "fPath"
        "fClass",  // 7 = "fClass"
        "fWeight"  // 8 = "fWeight"
    ]

    static func parse(reader: JsonObject): Font {
        var family: String = ""
        var name: String = ""
        var style: String = ""
        var ascent: Float64 = 0.0

        var fOrigin: String = ""
        var origin: Int64 = -1
        var fPath: String = ""
        var fClass: String = ""
        var fWeight: String = ""

        if (let Some(v) <- reader.get(NAMES[0])) { //"fFamily"
            family = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { //"fName"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) { //"fStyle"
            style = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[3])) { //"ascent"
            ascent = v.asFloat().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[4])) { // 4 = "fOrigin"
            fOrigin = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // 5 = "origin"
            origin = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // 6 = "fPath"
            fPath = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[7])) { // 7 = "fClass"
            fClass = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // 8 = "fWeight"
            fWeight = v.asString().getValue()
        }

        return Font(family, name, style, ascent, fOrigin, origin, fPath, fClass, fWeight)
    }
}
