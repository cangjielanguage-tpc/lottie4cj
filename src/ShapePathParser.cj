/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

class ShapePathParser {

    private static let NAMES: Array<String> = [
        "nm",    //0
        "ind",   //1
        "ks",    //2
        "hd"     //3
    ]

    static func parse(reader: JsonValue, composition: AnimationData): ShapePath {
        var name: String = ""
        var ind: Int64 = 0

        var shape: ArrayList<Keyframe<ShapeData>> = ArrayList<Keyframe<ShapeData>>()
        var hidden: Bool = false

        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(NAMES[0])) { // "nm"
            name = jo[NAMES[0]].asString().getValue()
        }
        if (jo.containsKey(NAMES[1])) { // //"ind"
            ind = jo[NAMES[1]].asInt().getValue()
        }
        if (jo.containsKey(NAMES[2])) { // "ks"
            let jv: JsonValue = jo[NAMES[2]]
            shape = AnimatableValueParser.parseShapeData(jv, composition)
        }
        if (jo.containsKey(NAMES[3])) { // "hd"
            hidden = jo[NAMES[3]].asBool().getValue()
        }
        let cm: ShapePath = ShapePath()
        cm.nm = name
        cm.ind = ind
        cm.ks = shape
        cm.hd = hidden
        return cm
    }
}
