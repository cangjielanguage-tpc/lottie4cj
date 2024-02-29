/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ShapeFillParser {

    private static let NAMES: Array<String> = [
        "nm",          // 0
        "c",           // 1
        "o",           // 2
        "fillEnabled", // 3
        "r",           // 4
        "hd"           // 5
    ]

    static func parse(reader: JsonObject): ShapeFill {
        var color: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
        var fillEnabled: Bool = false
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()

        var name: String = ""
        var fillTypeInt: Int64 = 1
        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { //"c"  //"layers"."shapes"."c"  <==  "layers"."shapes".{"ty": "fl"}
            let jv: JsonValue = reader[NAMES[1]]
            color = AnimatableValueParser.parseColor(jv)
        }
        if (reader.containsKey(NAMES[2])) { // "o"
            let jv: JsonValue = reader[NAMES[2]]
            opacity = AnimatableValueParser.parseInteger(jv)
        }
        if (reader.containsKey(NAMES[3])) { //"fillEnabled"
            fillEnabled = reader[NAMES[3]].asBool().getValue()
        }
        if (reader.containsKey(NAMES[4])) { // "r"
            fillTypeInt = reader[NAMES[4]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[5])) { // "hd"
            hidden = reader[NAMES[5]].asBool().getValue()
        }

        let cm: ShapeFill = ShapeFill()
        cm.nm = name
        cm.c = color
        cm.o = opacity
        cm.fillEnabled = fillEnabled
        cm.r = fillTypeInt
        cm.hd = hidden
        return cm
    }
}
