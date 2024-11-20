/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class RepeaterParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "c",    // 1
        "o",    // 2
        "tr",   // 3
        "hd",   // 4
        "ix",   // 5
        "m"     // 6
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): Repeater {
        var name: String = ""

        var copies: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var offset: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var transform: AnimatableTransform = AnimatableTransform()

        var hidden: Bool = false
        var ix: Int64 = -1
        var m: Int64 = -1

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "c"
            copies.k = AnimatableValueParser.parseFloat(v)
            handleAIX(v, copies)
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "o"
            offset.k = AnimatableValueParser.parseFloat(v)
            handleAIX(v, offset)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "tr"
            transform = AnimatableTransformParser.parse(v.asObject())
        }
        if (let Some(v) <- reader.get(NAMES[4])) { //"hd"
            hidden = v.asBool().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[5])) { // "ix"
            ix = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "m"
            m = v.asInt().getValue()
        }
        let cm: Repeater = Repeater(
            nm: name,
            c: copies,
            o: offset,
            tr: transform,
            hd: hidden,
            ix: ix,
            m: m
        )
        return cm
    }

    private static func handleAIX(jv: JsonValue, keyframe: ArrayKeyframeFloat64): Unit {
        let jo: JsonObject = jv.asObject()
        if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
            keyframe.a = k.asInt().getValue()
        }
        if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
            keyframe.ix = k.asInt().getValue()
        }
    }

}
