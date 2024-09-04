/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class CircleShapeParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "p",    // 1
        "s",    // 2
        "hd",   // 3
        "d"     // 4
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): CircleShape {
        var name: String = ""
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayKeyframePointF = ArrayKeyframePointF()
        var reversed: Int64 = 0
        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[1])) {  //"p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) {  //"s"
            size.k = AnimatableValueParser.parsePoint(v)
            
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                size.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                size.ix = k.asInt().getValue()
            }
        }
        if (let Some(v) <- reader.get(NAMES[3])) {  //"hd"
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[4])) {  //"d"
            reversed = v.asInt().getValue()
        }

        let cm: CircleShape = CircleShape(
            nm: name,
            p: position,
            s: size,
            hd: hidden,
            d: reversed
        )
        return cm
    }
}
