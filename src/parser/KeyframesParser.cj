/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class KeyframesParser {

    static let NAMES: String = "k"

    static func parse<T>(reader: JsonValue, valueParser: ValueParser<T>): ArrayList<Keyframe<T>> where T <: ToString  {

        let keyframes: ArrayList<Keyframe<T>> = ArrayList<Keyframe<T>>()

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsString)) {
            logger.log(LogLevel.INFO,"Lottie doesn't support expressions.")
            return keyframes
        }

        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(NAMES)) {
            let jv: JsonValue = jo[NAMES]
            jk = jv.kind()
            if (equalsJsonKind(jk, JsonKind.JsArray)) {
                let ja: JsonArray = jv.asArray()
                let len: Int64 = ja.size()
                if (len <= 0) {
                    return keyframes
                }
                jk = ja[0].kind()
                if (equalsJsonKind(jk, JsonKind.JsInt) || equalsJsonKind(jk, JsonKind.JsFloat)) {
                    keyframes.append(KeyframeParser.parse(jv, valueParser, false))
                } else {
                    for (i in 0..len) {
                        let jsonValue: JsonValue = ja[i]
                        keyframes.append(KeyframeParser.parse(jsonValue, valueParser, true))
                    }
                }
            } else {
                keyframes.append(KeyframeParser.parse(jv, valueParser, false))
            }
        }
        return keyframes
    }
}
