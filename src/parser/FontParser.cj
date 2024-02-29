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

        if (reader.containsKey(NAMES[0])) {  //"fFamily" 
            family = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) {  //"fName"
            name = reader[NAMES[1]].asString().getValue()
        }
        if (reader.containsKey(NAMES[2])) {  //"fStyle"
            style = reader[NAMES[2]].asString().getValue()
        }
        if (reader.containsKey(NAMES[3])) {  //"ascent"
            ascent = reader[NAMES[3]].asFloat().getValue()
        }
        return Font(family, name, style, ascent)
    }
}
