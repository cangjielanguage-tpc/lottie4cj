/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.parser

class BlurEffectParser {

    private static let BLUR_EFFECT_NAMES: String = "ef"
    private static let INNER_BLUR_EFFECT_NAMES: Array<String> = [
        "ty",
        "v",
        "nm",
        "mn",
        "ix"
    ]


    static func parse(reader: JsonObject): Array<Effect> {

        var ef: Array<Effect> = Array<Effect>()
        if (let Some(v) <- reader.get(BLUR_EFFECT_NAMES)) { //"layers"."ef"."ef"
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            let EMPTY_EFFECT: Effect = Effect()
            ef = Array<Effect>(len, item: EMPTY_EFFECT)
            for (i in 0..len) {
                let jo: JsonObject = ja[i].asObject()
                let be: Effect = maybeParseInnerEffect(jo)
                ef[i] = be
            }
        }
        return ef
    }

    private static func maybeParseInnerEffect(reader: JsonObject): Effect {

        var blurEffect: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var isCorrectType: Int64 = 0
        var isNull: Bool = true

        var nm: String = ""
        var mn: String = ""
        var ix: Int64 = 0

        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[0])) {//"ty" //"layers"[i]."ef"."ef"[i]."ty"
            isCorrectType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[1])) {//"v" //"layers"[i]."ef"."ef"[i]."v"
            blurEffect = AnimatableValueParser.parseArrayFloat(v)
            isNull = false
        }
        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[2])) {//"nm" //"layers"[i]."ef"."ef"[i]."nm"
            nm = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[3])) {//"mn" //"layers"[i]."ef"."ef"[i]."mn"
            mn = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[4])) {//"ix" //"layers"[i]."ef"."ef"[i]."ix"
            ix = v.asInt().getValue()
        }

        return Effect(ty: isCorrectType, nm: "", v: ContentModelPK(k: blurEffect), mn: mn, ix: ix, isNull: isNull)
    }
}
