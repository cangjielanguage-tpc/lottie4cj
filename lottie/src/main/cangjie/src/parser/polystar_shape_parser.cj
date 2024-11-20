/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class PolystarShapeParser {
    static func parse(reader: JsonReader): PolystarShape {
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
        var mn: String = ""
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "sy" => types = reader.readValue<Int64>()
                case "pt" => points.k = AnimatableValueParser.parseFloat(reader)
                case "p" => position = AnimatablePathValueParser.parseSplitPath(reader)
                case "r" => rotation.k = AnimatableValueParser.parseFloat(reader)
                case "or" => outerRadius.k = AnimatableValueParser.parseFloat(reader)
                case "os" => outerRoundedness.k = AnimatableValueParser.parseFloat(reader)
                case "ir" => innerRadius.k = AnimatableValueParser.parseFloat(reader)
                case "is" => innerRoundedness.k = AnimatableValueParser.parseFloat(reader)
                case "hd" => hidden = reader.readValue<Bool>()
                case "d" => reversed = reader.readValue<Int64>()
                case "ix" => ix = reader.readValue<Int64>()
                case "mn" => mn = reader.readValue<String>()
                case _ => reader.skip()
            }
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
        if (!mn.isEmpty()) {
            cm.mn = mn
        }
        return cm
    }
}
