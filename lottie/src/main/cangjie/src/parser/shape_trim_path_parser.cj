/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class ShapeTrimPathParser {

    private static let NAMES: Array<String> = [
        "s",    // 0
        "e",    // 1
        "o",    // 2
        "nm",   // 3
        "m",    // 4
        "hd"    // 5
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): ShapeTrimPath {
        var name: String = ""
        var types: Int64 = 0

        let start: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        let end: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        let offset: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()

        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) {  //"s"
            start.k = AnimatableValueParser.parseFloat(v)
            handleAIX(v, start)
        }
        if (let Some(v) <- reader.get(NAMES[1])) {  //"e"
            end.k = AnimatableValueParser.parseFloat(v)
            handleAIX(v, end)
        }
        if (let Some(v) <- reader.get(NAMES[2])) {  //"o"
            offset.k = AnimatableValueParser.parseFloat(v)
            handleAIX(v, offset)
        }
        if (let Some(v) <- reader.get(NAMES[3])) {  //"nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[4])) {  //"m"
            types = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) {  //"hd"
            hidden = v.asBool().getValue()
        }

        let cm: ShapeTrimPath = ShapeTrimPath(
            s: start,
            e: end,
            o: offset,
            nm: name,
            m: types,
            hd: hidden
        )
        return cm
    }
}
