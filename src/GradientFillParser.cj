/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

class GradientFillParser {

    private static let NAMES: Array<String> = [
        "nm",     //0
        "g",      //1
        "o",      //2
        "t",      //3
        "s",      //4
        "e",      //5
        "r",      //6
        "hd"      //7
    ]
    private static let GRADIENT_NAMES: Array<String> = [
        "p",
        "k"
    ]

    static func parse(reader: JsonObject, composition: AnimationData): GradientFill {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()
        var gradientType: Int64 = 0
        var startPoint: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var endPoint: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var fillType: Int64 = 0
        var hidden: Bool = false

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
                g.k = AnimatableValueParser.parseGradientColor(jv, composition, points)
            }
        }

        if (reader.containsKey(NAMES[2])) { // "o"
            let jv: JsonValue = reader[NAMES[2]]
            opacity = AnimatableValueParser.parseInteger(jv, composition)
        }
        if (reader.containsKey(NAMES[3])) { // "t"
            gradientType = reader[NAMES[3]].asInt().getValue()
        }

        if (reader.containsKey(NAMES[4])) { // "s"
            let jv: JsonValue = reader[NAMES[4]]
            startPoint = AnimatableValueParser.parsePoint(jv, composition)
        }
        if (reader.containsKey(NAMES[5])) { // "e"
            let jv: JsonValue = reader[NAMES[5]]
            endPoint = AnimatableValueParser.parsePoint(jv, composition)
        }

        if (reader.containsKey(NAMES[6])) { // "r"
            fillType = reader[NAMES[6]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[7])) { // "hd"
            hidden = reader[NAMES[7]].asBool().getValue()
        }

        let cm: GradientFill = GradientFill()
        cm.nm = name
        cm.g = g
        cm.o = opacity
        cm.t = gradientType
        cm.s = startPoint
        cm.e = endPoint
        cm.r = fillType
        cm.hd = hidden
        return cm
    }
}
