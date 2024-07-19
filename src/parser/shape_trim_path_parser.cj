/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class ShapeTrimPathParser {

    private static let NAMES: Array<String> = [
        "s",    // 0
        "e",    // 1
        "o",    // 2
        "nm",   // 3
        "m",    // 4
        "hd"    // 5
    ]

    static func parse(reader: JsonObject): ShapeTrimPath {
        var name: String = ""
        var types: Int64 = 0

        let EMPTY_KFF64: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var start: Array<Keyframe<Float64>> = EMPTY_KFF64
        var end: Array<Keyframe<Float64>> = EMPTY_KFF64
        var offset: Array<Keyframe<Float64>> = EMPTY_KFF64

        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) {  //"s"
            start = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[1])) {  //"e"
            end = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) {  //"o"
            offset = AnimatableValueParser.parseFloat(v)
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
