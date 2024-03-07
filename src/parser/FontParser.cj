/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class FontParser {
    
    /* "fonts"."list"[{.}] */
    private static let NAMES: Array<String> = [
        "fFamily", // 0 = family
        "fName",   // 1 = name
        "fStyle",  // 2 = style
        "ascent"   // 3 = ascent
    ]

    static func parse(reader: JsonObject): Font {
        var family: String = ""
        var name: String = ""
        var style: String = ""
        var ascent: Float64 = 0.0

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
        return Font(family, name, style, ascent)
    }
}
