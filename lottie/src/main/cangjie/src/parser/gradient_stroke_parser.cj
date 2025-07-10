/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class GradientStrokeParser {
    static func parse(reader: JsonReader): GradientStroke {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var gradientType: Int64 = 0
        var startPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var endPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var width: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false

        var lineDashPattern = ArrayList<ContentModelD>()
        var a: AK = AK()

        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" =>
                    name = reader.readValue<String>()
                case "g" =>
                    var points: Int64 = -1
                    var p: Int64 = 0
                    var k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "p" => points = reader.readValue<Int64>()
                            case "k" => k = AnimatableValueParser.parseGradientColor(reader, points)
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                    g = ContentModelP(p: p, k: k)
                case "o" => opacity = AnimatableValueParser.parseInteger(reader)
                case "t" => gradientType = reader.readValue<Int64>()
                case "s" => startPoint = AnimatableValueParser.parseArrayFloat(reader)
                case "e" => endPoint = AnimatableValueParser.parseArrayFloat(reader)
                case "w" => width = AnimatableValueParser.parseFloat(reader)
                case "lc" => capType = reader.readValue<Int64>()
                case "lj" => joinType = reader.readValue<Int64>()
                case "ml" => miterLimit = reader.readValue<Float64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case "a" => a = Utils.parseSAK(reader)
                case "d" =>
                    var n: String = ""
                    var v: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        reader.startObject()
                        while (reader.peek() != EndObject) {
                            match (reader.readName()) {
                                case "n" => n = reader.readValue<String>()
                                case "v" => v = AnimatableValueParser.parseFloat(reader)
                                case _ => reader.skip()
                            }
                        }
                        reader.endObject()
                        let cmd: ContentModelD = ContentModelD(n: n, v: ContentModelDK(k: v))
                        lineDashPattern.add(cmd)
                    }
                    reader.endArray()
                case _ => reader.skip()
            }
        }

        GradientStroke(
            nm: name,
            g: g,
            o: opacity,
            t: gradientType,
            s: startPoint,
            e: endPoint,
            w: width,
            lc: capType,
            lj: joinType,
            ml: miterLimit,
            hd: hidden,
            d: lineDashPattern.toArray(),
            a: a
        )
    }
}
