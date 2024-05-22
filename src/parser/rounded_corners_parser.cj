/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class RoundedCornersParser {

    private static let NAMES: Array<String> = [
        "nm", // 0
        "r",  // 1
        "hd"  // 2
    ]

    static func parse(reader: JsonObject): RoundedCorners {
        var name: String = ""
        var cornerRadius: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>() //用例1/2
        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "r"
            cornerRadius = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "hd"
            hidden = v.asBool().getValue()
        }

        let cm: RoundedCorners = RoundedCorners(nm: name, r: cornerRadius, hd: hidden)
        return cm
    }
}
