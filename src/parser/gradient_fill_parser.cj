/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

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
        "mn"      //8
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

        var startPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var endPoint: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var fillType: Int64 = 0
        var hidden: Bool = false

        var mn: String = ""

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
            startPoint = AnimatableValueParser.parseArrayFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "e"
            endPoint = AnimatableValueParser.parseArrayFloat(v)
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

        let cm: GradientFill = GradientFill(
            nm: name,
            g: g,
            o: opacity,
            t: gradientType,
            s: startPoint,
            e: endPoint,
            r: fillType,
            hd: hidden,
            mn: mn
        )
        return cm
    }
}
