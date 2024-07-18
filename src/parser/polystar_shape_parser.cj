/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

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
        "d"     // 10
    ]

    static func parse(reader: JsonObject): PolystarShape {
        var name: String = ""
        var types: Int64 = 0
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()

        let EMPTY_KFF64: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var points: Array<Keyframe<Float64>> = EMPTY_KFF64
        var rotation: Array<Keyframe<Float64>> = EMPTY_KFF64
        var outerRadius: Array<Keyframe<Float64>> = EMPTY_KFF64
        var outerRoundedness: Array<Keyframe<Float64>> = EMPTY_KFF64
        var innerRadius: Array<Keyframe<Float64>> = EMPTY_KFF64
        var innerRoundedness: Array<Keyframe<Float64>> = EMPTY_KFF64

        var hidden: Bool = false
        var reversed: Int64 = 0

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "sy"
            types = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "pt"
            points = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }
        if (let Some(v) <- reader.get(NAMES[4])) { // "r"
            rotation = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "or"
            outerRadius = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "os"
            outerRoundedness = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[7])) { // "ir"
            innerRadius = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // "is"
            innerRoundedness = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[9])) { // "hd"
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[10])) { // "d"
            reversed = v.asInt().getValue()
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
            d: reversed
        )
        return cm
    }
}
