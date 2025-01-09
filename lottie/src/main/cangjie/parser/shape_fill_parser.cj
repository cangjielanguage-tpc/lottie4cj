/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class ShapeFillParser {
    static func parse(reader: JsonReader): ShapeFill {
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var fillEnabled: Bool = false
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()

        var name: String = ""
        var fillTypeInt: Int64 = 1
        var hidden: Bool = false
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "c" => color = AnimatableValueParser.parseColor(reader)
                case "o" => opacity = AnimatableValueParser.parseInteger(reader)
                case "fillEnabled" => fillEnabled = reader.readValue<Bool>()
                case "r" => fillTypeInt = reader.readValue<Int64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case _ => reader.skip()
            }
        }

        return ShapeFill(
            nm: name,
            c: color,
            o: opacity,
            fillEnabled: fillEnabled,
            r: fillTypeInt,
            hd: hidden
        )
    }
}
