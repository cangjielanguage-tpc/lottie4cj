/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.parser

class PolystarShapeParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "sy",   // 1
        "pt",   // 2
        "p",    // 3
        "r",    // 4
        "or",   // 5
        "os",   // 6
        "ir",   // 7
        "is",   // 8
        "hd",   // 9
        "d",    // 10
        "ix",   // 11
        "mn"    // 12
    ]

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    static func parse(reader: JsonObject): PolystarShape {
        var name: String = ""
        var types: Int64 = 0
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()

        var points: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var rotation: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var outerRadius: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var outerRoundedness: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var innerRadius: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var innerRoundedness: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()

        var hidden: Bool = false
        var reversed: Int64 = 0
        var ix: Int64 = -1

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "sy"
            types = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "pt"
            points.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, points)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }
        if (let Some(v) <- reader.get(NAMES[4])) { // "r"
            rotation.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, rotation)
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "or"
            outerRadius.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, outerRadius)
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "os"
            outerRoundedness.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, outerRoundedness)
        }
        if (let Some(v) <- reader.get(NAMES[7])) { // "ir"
            innerRadius.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, innerRadius)
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // "is"
            innerRoundedness.k = AnimatableValueParser.parseFloat(v)

            handleAIX(v, innerRoundedness)
        }
        if (let Some(v) <- reader.get(NAMES[9])) { // "hd"
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[10])) { // "d"
            reversed = v.asInt().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[11])) { // "ix"
            ix = v.asInt().getValue()
        }

        let cm: PolystarShape = PolystarShape(
            nm: name,
            sy: types,
            pt: points,
            p: position,
            r: rotation,
            or: outerRadius,
            os: outerRoundedness,
            ir: innerRadius,
            is2: innerRoundedness,
            hd: hidden,
            d: reversed,
            ix: ix
        )
        if (let Some(v) <- reader.get(NAMES[12])) { // "mn"
            cm.mn = v.asString().getValue()
        }
        
        return cm
    }

    private static func handleAIX(jv: JsonValue, keyframe: ArrayKeyframeFloat64): Unit {
        let jo: JsonObject = jv.asObject()
        if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
            keyframe.a = k.asInt().getValue()
        }
        if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
            keyframe.ix = k.asInt().getValue()
        }
    }

}
