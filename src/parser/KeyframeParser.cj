/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser


class KeyframeParser {

    static let NAMES: Array<String> = [
        "t",  // 0
        "s",  // 1
        "e",  // 2
        "o",  // 3
        "i",  // 4
        "h",  // 5
        "to", // 6
        "ti"  // 7
    ]
    static let INTERPOLATOR_NAMES: Array<String> = [
        "x",  // 0
        "y"   // 1
    ]

    static func parse<T>(reader: JsonValue, valueParser: ValueParser<T>, animated: Bool):
                            Keyframe<T> where T <: ToString  {

        if (animated) {
            return parseKeyframe<T>(reader, valueParser)
        } else {
            return parseStaticValue<T>(reader, valueParser)
        }
    }

    private static func parseKeyframe<T>(reader: JsonValue, valueParser: ValueParser<T>): Keyframe<T> where T <: ToString  {

        var cp1: PointF = PointF()
        var cp2: PointF = PointF()

        var startFrame: Float64 = 0.0
        var startValue: Option<T> = Option<T>.None
        var endValue: Option<T> = Option<T>.None

        var hold: Int64 = 0

        // Only used by PathKeyframe
        var pathCp1: PointF = PointF()
        var pathCp2: PointF = PointF()


        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(NAMES[0])) { // t
            startFrame = jo[NAMES[0]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[1])) { // s
            let jv: JsonValue = jo[NAMES[1]]

            if (equalsJsonKind(jv.kind(), JsonKind.JsArray)) {
                let ja: JsonArray = jv.asArray()
                let len: Int64 = ja.size()
                if (len > 0) {
                    let jsonValue: JsonValue = ja[0]
                    let jk: JsonKind = jsonValue.kind()

                    if (equalsJsonKind(jk, JsonKind.JsObject)) {
                        startValue = valueParser.parse(ja[0])
                    } else {
                        startValue = valueParser.parse(jv)
                    }
                }
            } else {
                startValue = valueParser.parse(jv)
            }
        }
        if (jo.containsKey(NAMES[2])) { // e
            let jv: JsonValue = jo[NAMES[2]]
            if (equalsJsonKind(jv.kind(), JsonKind.JsArray)) {
                let ja: JsonArray = jv.asArray()
                let len: Int64 = ja.size()

                if (len > 0) {
                    let jsonValue: JsonValue = ja[0]
                    let jk: JsonKind = jsonValue.kind()

                    if (equalsJsonKind(jk, JsonKind.JsObject)) {
                        endValue = valueParser.parse(ja[0])
                    } else {
                        endValue = valueParser.parse(jv)
                    }
                }
            } else {
                endValue = valueParser.parse(jv)
            }
        }
        if (jo.containsKey(NAMES[3])) { // o
            let jv: JsonValue = jo[NAMES[3]]
            cp1 = JsonUtils.jsonToPoint(jv)
        }
        if (jo.containsKey(NAMES[4])) { // i
            let jv: JsonValue = jo[NAMES[4]]
            cp2 = JsonUtils.jsonToPoint(jv)
        }
        if (jo.containsKey(NAMES[5])) { // h
            hold = jo[NAMES[5]].asInt().getValue()
        }
        if (jo.containsKey(NAMES[6])) { // to
            let jv: JsonValue = jo[NAMES[6]]
            pathCp1 = JsonUtils.jsonToPoint(jv)
        }
        if (jo.containsKey(NAMES[7])) { // ti
            let jv: JsonValue = jo[NAMES[7]]
            pathCp2 = JsonUtils.jsonToPoint(jv)
        }

        let keyframe: Keyframe<T> = Keyframe<T>()
        keyframe.t = startFrame
        keyframe.s = startValue
        keyframe.e = endValue
        keyframe.o = cp1
        keyframe.i = cp2
        keyframe.h = hold
        keyframe.to = pathCp1
        keyframe.ti = pathCp2

        return keyframe
    }

    private static func parseStaticValue<T>(reader: JsonValue, valueParser: ValueParser<T>): Keyframe<T> where T <: ToString  {
        let value: T = valueParser.parse(reader)
        return Keyframe<T>(value)
    }

}
