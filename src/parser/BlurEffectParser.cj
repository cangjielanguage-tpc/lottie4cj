/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class BlurEffectParser {

    private static let BLUR_EFFECT_NAMES: String = "ef"
    private static let INNER_BLUR_EFFECT_NAMES: Array<String> = [
        "ty",
        "v"
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

        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[0])) {//"ty" //"layers"."ef"."ef"."ty"
            isCorrectType = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(INNER_BLUR_EFFECT_NAMES[1])) {//"v" //"layers"."ef"."ef"."v"
            blurEffect = AnimatableValueParser.parseArrayFloat(v)
            isNull = false
        }

        return Effect(ty: isCorrectType, nm: "", v: ContentModelPK(k: blurEffect), isNull: isNull)
    }
}
