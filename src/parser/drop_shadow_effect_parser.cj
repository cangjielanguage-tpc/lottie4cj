/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class DropShadowEffectParser {

    private static let DROP_SHADOW_EFFECT_NAMES: String = "ef"

    private static let INNER_EFFECT_NAMES: Array<String> = [
        "nm",
        "v",
        "ty"
    ]

    func parse(reader: JsonObject): Array<Effect> {
      
        var ef: Array<Effect> = Array<Effect>()
        if (let Some(v) <- reader.get(DROP_SHADOW_EFFECT_NAMES)) { //"layers"."ef"."ef"
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            let EMPTY_EFFECT: Effect = Effect()
            ef = Array<Effect>(len, item: EMPTY_EFFECT)
            for (i in 0..len) {
                let jo: JsonObject = ja[i].asObject()
                let dse: Effect = maybeParseInnerEffect(jo)
                ef[i] = dse
            }
        }
        return ef
    }

    private func maybeParseInnerEffect(reader: JsonObject): Effect {

        var currentEffectName: String = ""
        var isCorrectType: Int64 = 0
        var v: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var isNull: Bool = true

        if (let Some(k) <- reader.get(INNER_EFFECT_NAMES[0])) { //"nm" //"layers"."ef"."ef"."nm"
            currentEffectName = k.asString().getValue()
        }
        if (let Some(k) <- reader.get(INNER_EFFECT_NAMES[1])) {//"v" //"layers"."ef"."ef"."v"
            if (currentEffectName == "Shadow Color") {
                v = AnimatableValueParser.parseColor(k)
                isNull = false
            } else if (currentEffectName == "Opacity" || currentEffectName == "Direction") {
                v = AnimatableValueParser.parseArrayFloat(k)
                isNull = false
            } else if (currentEffectName == "Distance" || currentEffectName == "Softness") {
                v = AnimatableValueParser.parseArrayFloat(k)
                isNull = false
            }
        }

        if (let Some(k) <- reader.get(INNER_EFFECT_NAMES[2])) {//"ty" //"layers"."ef"."ef"."ty"
            isCorrectType = k.asInt().getValue()
        }

        let dse: Effect = Effect(
            ty: isCorrectType,
            nm: currentEffectName,
            v: ContentModelPK(k: v),
            isNull: isNull
        )
        return dse
    }
}
