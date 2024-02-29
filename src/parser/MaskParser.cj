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

    static func parse(jo: JsonObject, composition: AnimationData): Mask {

        var cl: Bool = false
        var inverted: Bool = false
        var maskMode: String = ""
        var maskPath: ArrayList<Keyframe<ShapeData>> = ArrayList<Keyframe<ShapeData>>()
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()
        var x: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()
        var nm: String = ""

        if (jo.containsKey(NAMES[0])) { //"cl"
            cl = jo[NAMES[0]].asBool().getValue()
        }
        if (jo.containsKey(NAMES[1])) { //"inv"
            inverted = jo[NAMES[1]].asBool().getValue()
        }
        if (jo.containsKey(NAMES[2])) { //"inv"
            maskMode = jo[NAMES[2]].asString().getValue()
        }

        if (jo.containsKey(NAMES[3])) { //"pt"
            let jsonObject: JsonObject = jo[NAMES[3]].asObject()
            maskPath = AnimatableValueParser.parseShapeData(jsonObject, composition)
        }

        if (jo.containsKey(NAMES[4])) { //"o"
            let jsonObject: JsonObject = jo[NAMES[4]].asObject()
            opacity = AnimatableValueParser.parseInteger(jsonObject, composition)
        }

        if (jo.containsKey(NAMES[5])) { //"x"
            let jsonObject: JsonObject = jo[NAMES[5]].asObject()
            x = AnimatableValueParser.parseInteger(jsonObject, composition)
        }

        if (jo.containsKey(NAMES[6])) { //"nm"
            nm = jo[NAMES[6]].asString().getValue()
        }
        return Mask(cl, inverted, maskMode, maskPath, opacity, x, nm)
    }
}
