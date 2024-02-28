/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class KeyframesParser {

    static let NAMES: String = "k"

    static func parse<T>(reader: JsonValue, composition: AnimationData, scale: Float64, valueParser: ValueParser<T>,
                            multiDimensional: Bool): ArrayList<Keyframe<T>> where T <: ToString  {

        let keyframes: ArrayList<Keyframe<T>> = ArrayList<Keyframe<T>>()

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsString)) {
            composition.addWarning("Lottie doesn't support expressions.")
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
                    keyframes.append(KeyframeParser.parse(jv, composition, scale, valueParser, false, multiDimensional))
                } else {
                    for (i in 0..len) {
                        let jsonValue: JsonValue = ja[i]
                        keyframes.append(KeyframeParser.parse(jsonValue, composition, scale, valueParser, true, multiDimensional))
                    }
                }
            } else {
                keyframes.append(KeyframeParser.parse(jv, composition, scale, valueParser, false, multiDimensional))
            }
        }
        return keyframes
    }
}
