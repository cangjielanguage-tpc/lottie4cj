/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.parser

class RectangleShapeParser {

    private static let NAMES: Array<String> = [
        "nm",    // 0
        "p",     // 1
        "s",     // 2
        "r",     // 3
        "hd",    // 4
        "d",     // 5
        "mn"     // 6
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): RectangleShape {
        var name: String = ""

        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayKeyframePointF = ArrayKeyframePointF()

        var roundedness: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var hidden: Bool = false
        var d: Int64 = -1

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
        if (let Some(v) <- reader.get(NAMES[3])) {  //"r"
            roundedness.k = AnimatableValueParser.parseFloat(v)
            
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                roundedness.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                roundedness.ix = k.asInt().getValue()
            }
        }

        if (let Some(v) <- reader.get(NAMES[4])) {  //"hd"
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) {  //"d"
            d = v.asInt().getValue()
        }
        
        let cm: RectangleShape = RectangleShape(
            nm: name,
            p: position,
            s: size,
            r: roundedness,
            hd: hidden,
            d: d
        )
        
        if (let Some(v) <- reader.get(NAMES[6])) { // "mn"
            cm.mn = v.asString().getValue()
        }
        return cm
    }
}
