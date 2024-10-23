/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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

    private static let NAMES: Array<String> = [
        "nm",     //0
        "g",      //1
        "o",      //2
        "t",      //3
        "s",      //4
        "e",      //5
        "r",      //6
        "hd",     //7
        "mn",     //8
        "a"       //9
    ]
    private static let GRADIENT_NAMES: Array<String> = [
        "p",
        "k"
    ]

    static func parse(reader: JsonObject): GradientFill {
        var name: String = ""
        var g: ContentModelP = ContentModelP()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var gradientType: Int64 = 0

        //var startPoint: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        //var endPoint: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var startPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var endPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var fillType: Int64 = 0
        var hidden: Bool = false

        var mn: String = ""
        var a: AK = AK()

        //var s_k: Array<Int64> = Array<Int64>()
        //var e_k: Array<Int64> = Array<Int64>()

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[1])) { // "g"  //("p": points/Int64, "k": color/Array<Keyframe<T>>)
            var points: Int64 = -1
            let jo: JsonObject = v.asObject()
            var gp: Int64 = 0
            var gk: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
            if (let Some(k) <- jo.get(GRADIENT_NAMES[0])) { // "p"
                gp = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(GRADIENT_NAMES[1])) { // "k"
                gk = AnimatableValueParser.parseGradientColor(k, points)
            }
            g = ContentModelP(p: gp, k: gk)
        }

        if (let Some(v) <- reader.get(NAMES[2])) { // "o"
            opacity = AnimatableValueParser.parseInteger(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "t"
            gradientType = v.asInt().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[4])) { // "s"
            //startPoint = AnimatableValueParser.parsePoint(v)
            startPoint = AnimatableValueParser.parseArrayFloat(v)

            //let jo: JsonObject = v.asObject()
            //if (let Some(k) <- jo.get("k") { // "k"
            //    try {
            //        let ja: JsonArray = k.asArray()
            //        let len: Int64 = ja.size()
            //        s_k = Array<Int64>(len, item: 0)
            //        for(i in 0..len) {
            //            s_k[i] = ja[i].asInt().getValue()
            //        }
            //    } catch (e: Exception) {
            //        startPoint = AnimatableValueParser.parsePoint(v)
            //    }
            //}
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "e"
            //endPoint = AnimatableValueParser.parsePoint(v)
            endPoint = AnimatableValueParser.parseArrayFloat(v)

            //let jo: JsonObject = v.asObject()
            //if (let Some(k) <- jo.get("k") { // "k"
            //    try {
            //        let ja: JsonArray = k.asArray()
            //        let len: Int64 = ja.size()
            //        e_k = Array<Int64>(len, item: 0)
            //        for(i in 0..len) {
            //            e_k[i] = ja[i].asInt().getValue()
            //        }
            //    } catch (e: Exception) {
            //        endPoint = AnimatableValueParser.parsePoint(v)
            //    }
            //}
        }

        if (let Some(v) <- reader.get(NAMES[6])) { // "r"
            fillType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[7])) { // "hd"
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // "mn"
            mn = v.asString().getValue()
        }
        
        if (let Some(v) <- reader.get(NAMES[9])) { //"a"
            let jo: JsonObject = v.asObject()
            //TODO: AK 中的 k 值可以是 Float64 类型，也可以是 Array<Keyframe<Array<Float64>>>。其中 Array<Float64> 是 [100.0] 长度为 1 的数组。 也可以写成 Array<Keyframe<Float64>>。
            //a = Utils.parseSAK(jo)
        }

        let cm: GradientFill = GradientFill(
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
        return cm
    }
}
