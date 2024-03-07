/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ShapeFillParser {

    private static let NAMES: Array<String> = [
        "nm",          // 0
        "c",           // 1
        "o",           // 2
        "fillEnabled", // 3
        "r",           // 4
        "hd"           // 5
    ]

    static func parse(reader: JsonObject): ShapeFill {
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var fillEnabled: Bool = false
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()

        var name: String = ""
        var fillTypeInt: Int64 = 1
        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { //"c"  //"layers"."shapes"."c"  <==  "layers"."shapes".{"ty": "fl"}
            color = AnimatableValueParser.parseColor(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "o"
            opacity = AnimatableValueParser.parseInteger(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { //"fillEnabled"
            fillEnabled = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[4])) { // "r"
            fillTypeInt = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "hd"
            hidden = v.asBool().getValue()
        }

        let cm: ShapeFill = ShapeFill(
            nm: name,
            c: color,
            o: opacity,
            fillEnabled: fillEnabled,
            r: fillTypeInt,
            hd: hidden
        )
        return cm
    }
}
