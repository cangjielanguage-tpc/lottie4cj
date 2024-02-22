/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ShapeStrokeParser {

    private static let NAMES: Array<String> = [
        "nm", // 0
        "c",  // 1
        "w",  // 2
        "o",  // 3
        "lc", // 4
        "lj", // 5
        "ml", // 6
        "hd", // 7
        "d"   // 8
    ]
    private static let DASH_PATTERN_NAMES: Array<String> = [
        "n",   // 0
        "v"    // 1
    ]

    static func parse(reader: JsonObject, composition: AnimationData): ShapeStroke {
        var name: String = ""
        var color: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

        var width: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false
        var lineDashPattern: ArrayList<ContentModelD> = ArrayList<ContentModelD>()

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { //"c"  //"layers"."shapes"."c"  <==  "layers"."shapes".{"ty": "st"}
            let jv: JsonValue = reader[NAMES[1]]
            color = AnimatableValueParser.parseColor(jv, composition)
        }
        if (reader.containsKey(NAMES[2])) {//"w"
            let jv: JsonValue = reader[NAMES[2]]
            width = AnimatableValueParser.parseFloat(jv, composition)
        }
        if (reader.containsKey(NAMES[3])) {//"o"
            let jo: JsonObject = reader[NAMES[3]].asObject()
            opacity = AnimatableValueParser.parseInteger(jo, composition)
        }

        if (reader.containsKey(NAMES[4])) { // "lc"
            capType = reader[NAMES[4]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[5])) { // "lj"
            joinType = reader[NAMES[5]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[6])) { // "ml"
            miterLimit = reader[NAMES[6]].asFloat().getValue()
        }

        if (reader.containsKey(NAMES[7])) { // "hd"
            hidden = reader[NAMES[7]].asBool().getValue()
        }

        //"d": [{"n": "String", "v": ArrayList<Keyframe<T>>}]  ==  ArrayList<ContentModelD>
        if (reader.containsKey(NAMES[8])) { // "d"
            let ja: JsonArray = reader[NAMES[8]].asArray()
            for (i in 0..ja.size()) {
                let jo: JsonObject = ja[i].asObject()
                var n: String = ""
                var v: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
                if (jo.containsKey(DASH_PATTERN_NAMES[0])) { // "n"
                    n = jo[DASH_PATTERN_NAMES[0]].asString().getValue()
                }
                if (jo.containsKey(DASH_PATTERN_NAMES[1])) { // "v"
                    v = AnimatableValueParser.parseFloat(reader, composition)
                }

                if (n == "g") {
                    let cmd: ContentModelD = ContentModelD(n: n, v: v)
                    lineDashPattern.append(cmd)
                }
            }
        }

        let cm: ShapeStroke = ShapeStroke()
        cm.nm = name
        cm.c = color
        cm.w = width
        cm.o = opacity
        cm.lc = capType
        cm.lj = joinType
        cm.ml = miterLimit
        cm.hd = hidden
        cm.d = lineDashPattern
        return cm
    }
}
