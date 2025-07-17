/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class RectangleShapeParser {
    static func parse(reader: JsonReader): RectangleShape {
        var name: String = ""

        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayKeyframePointF = ArrayKeyframePointF()

        var roundedness: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var hidden: Bool = false
        var d: Int64 = -1
        var mn: String = ""
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "p" => position = AnimatablePathValueParser.parseSplitPath(reader)
                case "s" => size.k = AnimatableValueParser.parsePoint(reader)
                case "r" => roundedness.k = AnimatableValueParser.parseFloat(reader)
                case "hd" => hidden = reader.readValue<Bool>()
                case "d" => d = reader.readValue<Int64>()
                case "mn" => mn = reader.readValue<String>()
                case _ => reader.skip()
            }
        }

        let cm: RectangleShape = RectangleShape(
            nm: name,
            p: position,
            s: size,
            r: roundedness,
            hd: hidden,
            d: d
        )
        if (!mn.isEmpty()) {
            cm.mn = mn
        }
        return cm
    }
}
