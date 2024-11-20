/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class CircleShapeParser {
    static func parse(reader: JsonReader): CircleShape {
        var name: String = ""
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayKeyframePointF = ArrayKeyframePointF()
        var reversed = 3
        var hidden = false

        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "p" => position = AnimatablePathValueParser.parseSplitPath(reader)
                case "s" => size.k = AnimatableValueParser.parsePoint(reader)
                case "hd" => hidden = reader.readValue<Bool>()
                case "d" => reversed = reader.readValue<Int64>() // "d" is 2 for normal and 3 for reversed.
                case _ => reader.skip()
            }
        }
        return CircleShape(
            nm: name,
            p: position,
            s: size,
            hd: hidden,
            d: reversed
        )
    }
}
