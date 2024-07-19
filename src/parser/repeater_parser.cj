/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class RepeaterParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "c",    // 1
        "o",    // 2
        "tr",   // 3
        "hd"    // 4
    ]

    static func parse(reader: JsonObject): Repeater {
        var name: String = ""

        var copies: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var offset: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var transform: AnimatableTransform = AnimatableTransform()

        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "c"
            copies = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "o"
            offset = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "tr"
            transform = AnimatableTransformParser.parse(v.asObject())
        }
        if (let Some(v) <- reader.get(NAMES[4])) { //"hd"
            hidden = v.asBool().getValue()
        }

        let cm: Repeater = Repeater(
            nm: name,
            c: copies,
            o: offset,
            tr: transform,
            hd: hidden
        )
        return cm
    }
}
