/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class MaskParser {

    //"layers"."masksProperties"
    private static let NAMES: Array<String> = [
        "cl",   // 0 = cl
        "inv",  // 1 = inverted
        "mode", // 2 = maskMode
        "pt",   // 3 = maskPath
        "o",    // 4 = opacity
        "x",    // 5 = x
        "nm"    // 6 = nm
    ]

    static func parse(jo: JsonObject): Mask {

        var cl: Bool = false
        var inverted: Bool = false
        var maskMode: String = ""
        var maskPath: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var x: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var nm: String = ""

        if (let Some(v) <- jo.get(NAMES[0])) { //"cl"
            cl = v.asBool().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[1])) { //"inv"
            inverted = v.asBool().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[2])) { //"inv"
            maskMode = v.asString().getValue()
        }

        if (let Some(v) <- jo.get(NAMES[3])) { //"pt"
            let jsonObject: JsonObject = v.asObject()
            maskPath = AnimatableValueParser.parseShapeData(jsonObject)
        }

        if (let Some(v) <- jo.get(NAMES[4])) { //"o"
            let jsonObject: JsonObject = v.asObject()
            opacity = AnimatableValueParser.parseInteger(jsonObject)
        }

        if (let Some(v) <- jo.get(NAMES[5])) { //"x"
            let jsonObject: JsonObject = v.asObject()
            x = AnimatableValueParser.parseInteger(jsonObject)
        }

        if (let Some(v) <- jo.get(NAMES[6])) { //"nm"
            nm = v.asString().getValue()
        }
        return Mask(cl: cl, inv: inverted, mode: maskMode, pt: maskPath, o: opacity, x: x, nm: nm)
    }
}
