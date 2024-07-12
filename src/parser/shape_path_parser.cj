/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package parser

class ShapePathParser {

    private static let NAMES: Array<String> = [
        "nm",    //0
        "ind",   //1
        "ks",    //2
        "hd"     //3
    ]

    static func parse(reader: JsonValue): ShapePath {
        var name: String = ""
        var ind: Int64 = 0

        var shape: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
        var hidden: Bool = false

        let jo: JsonObject = reader.asObject()
        if (let Some(v) <- jo.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[1])) { // //"ind"
            ind = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[2])) { // "ks"
            shape = AnimatableValueParser.parseShapeData(v)
        }
        if (let Some(v) <- jo.get(NAMES[3])) { // "hd"
            hidden = v.asBool().getValue()
        }
        let cm: ShapePath = ShapePath(
            nm: name,
            ind: ind,
            ks: shape,
            hd: hidden
        )
        return cm
    }
}
