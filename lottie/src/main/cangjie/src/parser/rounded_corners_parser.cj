/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class RoundedCornersParser {

    private static let NAMES: Array<String> = [
        "nm", // 0
        "r",  // 1
        "hd", // 2
        "ix"  // 3
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): RoundedCorners {
        var name: String = ""
        var cornerRadius: ArrayKeyframeFloat64 = ArrayKeyframeFloat64() //用例1/2
        var hidden: Bool = false
        var ix: Int64 = -1

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "r"
            cornerRadius.k = AnimatableValueParser.parseFloat(v)
            
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                cornerRadius.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                cornerRadius.ix = k.asInt().getValue()
            }
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "hd"
            hidden = v.asBool().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[3])) { // "ix"
            ix = v.asInt().getValue()
        }
        let cm: RoundedCorners = RoundedCorners(nm: name, r: cornerRadius, hd: hidden, ix: ix)
        return cm
    }
}
