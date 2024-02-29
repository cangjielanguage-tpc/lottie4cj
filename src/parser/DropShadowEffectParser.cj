/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class DropShadowEffectParser {

    private static let DROP_SHADOW_EFFECT_NAMES: String = "ef"

    private static let INNER_EFFECT_NAMES: Array<String> = [
        "nm",
        "v",
        "ty"
    ]

    func parse(reader: JsonObject): ArrayList<DropShadowEffect> {
      
        let ef: ArrayList<DropShadowEffect> = ArrayList<DropShadowEffect>()
        if (reader.containsKey(DROP_SHADOW_EFFECT_NAMES)) { //"layers"."ef"."ef"
            let ja: JsonArray = reader[DROP_SHADOW_EFFECT_NAMES].asArray()
            for (i in 0..ja.size()) {
                let jo: JsonObject = ja[i].asObject()
                let dse: DropShadowEffect = maybeParseInnerEffect(jo)
                ef.append(dse)
            }
        }
        return ef
    }

    private func maybeParseInnerEffect(reader: JsonObject): DropShadowEffect {

        var currentEffectName: String = ""
        var isCorrectType: Int64 = 0
        var v: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

        if (reader.containsKey(INNER_EFFECT_NAMES[0])) { //"nm" //"layers"."ef"."ef"."nm"
            currentEffectName = reader[INNER_EFFECT_NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(INNER_EFFECT_NAMES[1])) {//"v" //"layers"."ef"."ef"."v"
            if (currentEffectName == "Shadow Color") {
                v = AnimatableValueParser.parseColor(reader[INNER_EFFECT_NAMES[1]])
            } else if (currentEffectName == "Opacity" || currentEffectName == "Direction") {
                v = AnimatableValueParser.parseArrayFloat(reader[INNER_EFFECT_NAMES[1]])
            } else if (currentEffectName == "Distance" || currentEffectName == "Softness") {
                v = AnimatableValueParser.parseArrayFloat(reader[INNER_EFFECT_NAMES[1]])
            }
        }

        if (reader.containsKey(INNER_EFFECT_NAMES[2])) {//"ty" //"layers"."ef"."ef"."ty"
            isCorrectType = reader[INNER_EFFECT_NAMES[2]].asInt().getValue()
        }

        let dse: DropShadowEffect = DropShadowEffect()
        dse.ty = isCorrectType
        dse.nm = currentEffectName
        dse.v = ContentModelPK(v)
        return dse
    }
}
