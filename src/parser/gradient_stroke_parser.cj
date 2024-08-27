/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.parser

class GradientStrokeParser {

    private static let NAMES: Array<String> = [
        "nm",    //0
        "g",     //1
        "o",     //2
        "t",     //3
        "s",     //4
        "e",     //5
        "w",     //6
        "lc",    //7
        "lj",    //8
        "ml",    //9
        "hd",    //10
        "d",     //11
        "a"      //12
    ]
    private static let GRADIENT_NAMES: Array<String> = [
        "p",
        "k"
    ]
    private static let DASH_PATTERN_NAMES: Array<String> = [
        "n",
        "v"
    ]

    static func parse(reader: JsonObject): GradientStroke {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var gradientType: Int64 = 0
        var startPoint: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var endPoint: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var width: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false

        var lineDashPattern: Array<ContentModelD> = Array<ContentModelD>()
        var a: AK = AK()

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[1])) { // "g"  //("p": points/Int64, "k": color/Array<Keyframe<T>>)
            var points: Int64 = -1
            let jo: JsonObject = v.asObject()
            var p: Int64 = 0
            var k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
            if (let Some(val) <- jo.get(GRADIENT_NAMES[0])) { // "p"
                p = val.asInt().getValue()
            }

            if (let Some(val) <- jo.get(GRADIENT_NAMES[1])) { // "k"
                k = AnimatableValueParser.parseGradientColor(val, points)
            }
            g = ContentModelP(p: p, k: k)
        }

        if (let Some(v) <- reader.get(NAMES[2])) { // "o"
            opacity = AnimatableValueParser.parseInteger(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "t"
            gradientType = v.asInt().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[4])) { // "s"
            startPoint = AnimatableValueParser.parsePoint(v)
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "e"
            endPoint = AnimatableValueParser.parsePoint(v)
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "w"
            width = AnimatableValueParser.parseFloat(v)
        }

        if (let Some(v) <- reader.get(NAMES[7])) { // "lc"
            capType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // "lj"
            joinType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[9])) { // "ml"
            miterLimit = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[10])) { // "hd"
            hidden = v.asBool().getValue()
        }

        //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  ==  Array<ContentModelD>
        if (let Some(k) <- reader.get(NAMES[11])) { // "d"
            let ja: JsonArray = k.asArray()
            let len: Int64 = ja.size()
            if (len > 0) {
                let EMPTY_CMD: ContentModelD = ContentModelD(n: "", v: ContentModelDK())
                lineDashPattern = Array<ContentModelD>(len, item: EMPTY_CMD)
                for (i in 0..len) {
                    let jo: JsonObject = ja[i].asObject()
                    var n: String = ""
                    var v: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
                    if (let Some(val) <- jo.get(DASH_PATTERN_NAMES[0])) { // "n"
                        n = val.asString().getValue()
                    }
                    if (let Some(val) <- jo.get(DASH_PATTERN_NAMES[1])) { // "v"
                        v = AnimatableValueParser.parseFloat(val)
                    }

                    let cmd: ContentModelD = ContentModelD(n: n, v: ContentModelDK(k: v))
                    lineDashPattern[i] = cmd
                }
            }
        }

        if (let Some(v) <- reader.get(NAMES[12])) { //"a"
            let jo: JsonObject = v.asObject()
            a = Utils.parseSAK(jo)
        }

        let cm: GradientStroke = GradientStroke(
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
            d: lineDashPattern,
            a: a
        )
        return cm
    }
}
