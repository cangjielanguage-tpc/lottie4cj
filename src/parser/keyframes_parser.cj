/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class KeyframesParser {

    static let NAMES: String = "k"

    static func parse<T>(reader: JsonValue, valueParser: ValueParser<T>): Array<Keyframe<T>> where T <: ToString  {

        var keyframes: Array<Keyframe<T>> = Array<Keyframe<T>>()

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsString)) {
            logger.log(LogLevel.INFO, "Lottie doesn't support expressions.")
            return keyframes
        }

        let jo: JsonObject = reader.asObject()
        if (let Some(jv) <- jo.get(NAMES)) { // "k"
            jk = jv.kind()
            if (equalsJsonKind(jk, JsonKind.JsArray)) {
                let ja: JsonArray = jv.asArray()
                let len: Int64 = ja.size()
                if (len <= 0) {
                    return keyframes
                }
                jk = ja[0].kind()
                if (equalsJsonKind(jk, JsonKind.JsInt) || equalsJsonKind(jk, JsonKind.JsFloat)) {
                    keyframes = [KeyframeParser.parse(jv, valueParser, false)]
                } else {
                    keyframes = Array<Keyframe<T>>(len, repeat: Keyframe<T>())
                    for (i in 0..len) {
                        let jsonValue: JsonValue = ja[i]
                        keyframes[i] = KeyframeParser.parse(jsonValue, valueParser, true)
                    }
                }
            } else {
                keyframes = [KeyframeParser.parse(jv, valueParser, false)]
            }
        }
        return keyframes
    }
}
