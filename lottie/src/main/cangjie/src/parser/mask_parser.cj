/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class MaskParser {
    static func parse(reader: JsonReader): Mask {
        var cl: Bool = false
        var inverted: Bool = false
        var maskMode: String = ""
        var maskPath: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var x: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var nm: String = ""
        reader.startObject()
        while (reader.peek() != JsonToken.EndObject) {
            let name = reader.readName()
            match (name) {
                case "cl" => cl = reader.readValue<Bool>()
                case "inv" => inverted = reader.readValue<Bool>()
                case "mode" => maskMode = reader.readValue<String>()
                case "pt" => maskPath = AnimatableValueParser.parseShapeData(reader)
                case "o" => opacity = AnimatableValueParser.parseInteger(reader)
                case "x" => x = AnimatableValueParser.parseInteger(reader)
                case "nm" => nm = reader.readValue<String>()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return Mask(cl: cl, inv: inverted, mode: maskMode, pt: maskPath, o: opacity, x: x, nm: nm)
    }
}
