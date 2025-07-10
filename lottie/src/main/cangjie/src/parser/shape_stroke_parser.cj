/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class ShapeStrokeParser {
    static func parse(reader: JsonReader): ShapeStroke {
        var name: String = ""
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var width: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false
        var lineDashPattern = ArrayList<ContentModelD>(2)

        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "c" => color = AnimatableValueParser.parseColor(reader)
                case "w" => width = AnimatableValueParser.parseFloat(reader)
                case "o" => opacity = AnimatableValueParser.parseInteger(reader)
                case "lc" => capType = reader.readValue<Int64>()
                case "lj" => joinType = reader.readValue<Int64>()
                case "ml" => miterLimit = reader.readValue<Float64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case "d" =>
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        var n: String = ""
                        var val: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
                        reader.startObject()
                        while (reader.peek() != EndObject) {
                            match (reader.readName()) {
                                case "n" => n = reader.readValue<String>()
                                case "v" => val = AnimatableValueParser.parseFloat(reader)
                                case _ => reader.skip()
                            }
                        }
                        reader.endObject()

                        let cmd: ContentModelD = ContentModelD(n: n, v: ContentModelDK(k: val))
                        lineDashPattern.add(cmd)
                    }
                    reader.endArray()

                case _ => reader.skip()
            }
        }
        return ShapeStroke(
            nm: name,
            c: color,
            w: width,
            o: opacity,
            lc: capType,
            lj: joinType,
            ml: miterLimit,
            hd: hidden,
            d: lineDashPattern.toArray()
        )
    }
}
