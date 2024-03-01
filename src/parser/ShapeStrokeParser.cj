/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ShapeStrokeParser {

    private static let NAMES: Array<String> = [
        "nm", // 0
        "c",  // 1
        "w",  // 2
        "o",  // 3
        "lc", // 4
        "lj", // 5
        "ml", // 6
        "hd", // 7
        "d"   // 8
    ]
    private static let DASH_PATTERN_NAMES: Array<String> = [
        "n",   // 0
        "v"    // 1
    ]

    static func parse(reader: JsonObject): ShapeStroke {
        var name: String = ""
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()

        var width: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()
        var capType: Int64 = 0
        var joinType: Int64 = 0
        var miterLimit: Float64 = 0.0
        var hidden: Bool = false
        var lineDashPattern: Array<ContentModelD> = Array<ContentModelD>()

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { //"c"  //"layers"."shapes"."c"  <==  "layers"."shapes".{"ty": "st"}
            color = AnimatableValueParser.parseColor(v)
        }
        if (let Some(v) <- reader.get(NAMES[2])) {//"w"
            width = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- reader.get(NAMES[3])) {//"o"
            let jo: JsonObject = v.asObject()
            opacity = AnimatableValueParser.parseInteger(jo)
        }

        if (let Some(v) <- reader.get(NAMES[4])) { // "lc"
            capType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "lj"
            joinType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "ml"
            miterLimit = v.asFloat().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[7])) { // "hd"
            hidden = v.asBool().getValue()
        }

        //"d": [{"n": "String", "v": Array<Keyframe<T>>}]  ==  Array<ContentModelD>
        if (let Some(k) <- reader.get(NAMES[8])) { // "d"
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

        let cm: ShapeStroke = ShapeStroke(
            nm: name,
            c: color,
            w: width,
            o: opacity,
            lc: capType,
            lj: joinType,
            ml: miterLimit,
            hd: hidden,
            d: lineDashPattern
        )
        return cm
    }
}
