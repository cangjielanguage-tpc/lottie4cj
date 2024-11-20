/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

/**
 * s/e格式1：
 * {"ty":"gf",
 * "s":{"a":0,"k":[-2,-54]},
 * "e":{"a":0,"k":[98,8]},
 * }
 *
 * s/e格式2：
 * {"ty":"gf",
 * "s":{"a":1,"k":[{"i":{"x":0.833,"y":0.833},"o":{"x":0.167,"y":0.167},"n":"0p833_0p833_0p167_0p167","t":0,"s":[0,0],"e":[-2,-54],"to":[-0.33333334326744,-9],"ti":[0.33333334326744,9]},{"t":242}]},
 * "e":{"a":1,"k":[{"i":{"x":0.833,"y":0.833},"o":{"x":0.167,"y":0.167},"n":"0p833_0p833_0p167_0p167","t":0,"s":[-17,8],"e":[98,8],"to":[19.1666660308838,0],"ti":[-19.1666660308838,0]},{"t":242}]},
 * }
 *
 * h/a格式1：
 * {"ty":"gf",
 * "h":{"a":0,"k":0},
 * "a":{"a":0,"k":97.679},
 * }
 *
 * h/a格式2：
 * {"ty":"gf",
 * "h":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":722,"s":[0],"e":[100]},{"t":899}]},
 * "a":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":722,"s":[0],"e":[222]},{"t":899}]},
 * }
 */
class GradientFillParser {
    static func parse(reader: JsonReader): GradientFill {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var gradientType: Int64 = 0

        var startPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var endPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var fillType: Int64 = 0
        var hidden: Bool = false

        var mn: String = ""
        var a: AK = AK()

        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" =>
                    name = reader.readValue<String>()
                    break
                case "g" =>
                    var points: Int64 = -1
                    var gp: Int64 = 0
                    var gk: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "p" =>
                                gp = reader.readValue<Int64>()
                                break
                            case "k" =>
                                gk = AnimatableValueParser.parseGradientColor(reader, points)
                                break
                            case _ => reader.skip()
                        }
                    }
                    g = ContentModelP(p: gp, k: gk)
                    reader.endObject()
                    break
                case "o" => opacity = AnimatableValueParser.parseInteger(reader)
                case "t" => gradientType = reader.readValue<Int64>()
                case "s" => startPoint = AnimatableValueParser.parseArrayFloat(reader)
                case "e" => endPoint = AnimatableValueParser.parseArrayFloat(reader)
                case "r" => fillType = reader.readValue<Int64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case "mn" => mn = reader.readValue<String>()
                case "a" => a = Utils.parseSAK(reader)
                case _ => reader.skip()
            }
        }

        GradientFill(
            nm: name,
            g: g,
            o: opacity,
            t: gradientType,
            s: startPoint,
            e: endPoint,
            r: fillType,
            hd: hidden,
            mn: mn,
            a: a
        )
    }
}
