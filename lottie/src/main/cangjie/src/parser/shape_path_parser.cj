/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class ShapePathParser {
    static func parse(reader: JsonReader): ShapePath {
        var name: String = ""
        var ind = 0
        var shape: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
        var hidden = false
        var closed: Bool = false
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "ind" => ind = reader.readValue<Int64>()
                case "ks" => shape = AnimatableValueParser.parseShapeData(reader)
                case "hd" => hidden = reader.readValue<Bool>()
                case "closed" => closed = reader.readValue<Bool>()
                case _ => reader.skip()
            }
        }
        return ShapePath(
            nm: name,
            ind: ind,
            ks: shape,
            hd: hidden,
            closed: closed
        )
    }
}
