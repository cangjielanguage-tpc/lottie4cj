/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class RectangleShapeParser {

    private static let NAMES: Array<String> = [
        "nm",    // 0
        "p",     // 1
        "s",     // 2
        "r",     // 3
        "hd"     // 4
    ]

    static func parse(reader: JsonObject): RectangleShape {
        var name: String = ""

        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()

        var roundedness: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var hidden: Bool = false

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[1])) {  //"p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) {  //"s"
            size = AnimatableValueParser.parsePoint(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) {  //"s"
            roundedness = AnimatableValueParser.parseFloat(v)
        }

        if (let Some(v) <- reader.get(NAMES[4])) {  //"hd"
            hidden = v.asBool().getValue()
        }

        let cm: RectangleShape = RectangleShape(
            nm: name,
            p: position,
            s: size,
            r: roundedness,
            hd: hidden
        )
        return cm
    }
}
