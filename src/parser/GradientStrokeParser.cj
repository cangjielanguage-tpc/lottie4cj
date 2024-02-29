/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class GradientStrokeParser {

    private static let NAMES: Array<String> = [
        "nm",
        "g",
        "o",
        "t",
        "s",
        "e",
        "w",
        "lc",
        "lj",
        "ml",
        "hd",
        "d"
    ]
    private static let GRADIENT_NAMES: Array<String> = [
        "p",
        "k"
    ]
    private static let DASH_PATTERN_NAMES: Array<String> = [
        "n",
        "v"
    ]

    static func parse(reader: JsonObject): GradientStroke {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()
        var gradientType: Int64 = 0
        var startPoint: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var endPoint: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var width: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false

        var lineDashPattern: ArrayList<ContentModelD> = ArrayList<ContentModelD>()

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }

        if (reader.containsKey(NAMES[1])) { // "g"  //("p": points/Int64, "k": color/ArrayList<Keyframe<T>>)
            var points: Int64 = -1
            let jv: JsonValue = reader[NAMES[1]]
            let jo: JsonObject = jv.asObject()
            if (jo.containsKey(GRADIENT_NAMES[0])) { // "p"
                g.p = jo[GRADIENT_NAMES[0]].asInt().getValue()
            }

            if (jo.containsKey(GRADIENT_NAMES[1])) { // "k"
                g.k = AnimatableValueParser.parseGradientColor(jo[GRADIENT_NAMES[1]], points)
            }
        }

        if (reader.containsKey(NAMES[2])) { // "o"
            let jv: JsonValue = reader[NAMES[2]]
            opacity = AnimatableValueParser.parseInteger(jv)
        }
        if (reader.containsKey(NAMES[3])) { // "t"
            gradientType = reader[NAMES[3]].asInt().getValue()
        }

        if (reader.containsKey(NAMES[4])) { // "s"
            let jv: JsonValue = reader[NAMES[4]]
            startPoint = AnimatableValueParser.parsePoint(jv)
        }
        if (reader.containsKey(NAMES[5])) { // "e"
            let jv: JsonValue = reader[NAMES[5]]
            endPoint = AnimatableValueParser.parsePoint(jv)
        }
        if (reader.containsKey(NAMES[6])) { // "w"
            let jv: JsonValue = reader[NAMES[6]]
            width = AnimatableValueParser.parseFloat(jv)
        }

        if (reader.containsKey(NAMES[7])) { // "lc"
            capType = reader[NAMES[7]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[8])) { // "lj"
            joinType = reader[NAMES[8]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[9])) { // "ml"
            miterLimit = reader[NAMES[9]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[10])) { // "hd"
            hidden = reader[NAMES[10]].asBool().getValue()
        }

        //"d": [{"n": "String", "v": ArrayList<Keyframe<Float64>>}]  ==  ArrayList<ContentModelD>
        if (reader.containsKey(NAMES[11])) { // "d"
            let ja: JsonArray = reader[NAMES[11]].asArray()
            for (i in 0..ja.size()) {
                let jo: JsonObject = ja[i].asObject()
                var n: String = ""
                var v: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
                if (jo.containsKey(DASH_PATTERN_NAMES[0])) { // "n"
                    n = jo[DASH_PATTERN_NAMES[0]].asString().getValue()
                }
                if (jo.containsKey(DASH_PATTERN_NAMES[1])) { // "v"
                    v = AnimatableValueParser.parseFloat(reader)
                }

                if (n == "d" || n == "g") {
                    let cmd: ContentModelD = ContentModelD(n: n, v: ContentModelDK(v))
                    lineDashPattern.append(cmd)
                }
            }

        }

        let cm: GradientStroke = GradientStroke()
        cm.nm = name
        cm.g = g
        cm.o = opacity
        cm.t = gradientType
        cm.s = startPoint
        cm.e = endPoint
        cm.w = width
        cm.lc = capType
        cm.lj = joinType
        cm.ml = miterLimit
        cm.hd = hidden
        cm.d = lineDashPattern
        return cm
    }
}
