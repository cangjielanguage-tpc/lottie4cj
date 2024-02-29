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


    static func parse(reader: JsonObject, composition: AnimationData): ArrayList<BlurEffect> {

        let ef: ArrayList<BlurEffect> = ArrayList<BlurEffect>()
        if (reader.containsKey(BLUR_EFFECT_NAMES)) { //"layers"."ef"."ef"
            let ja: JsonArray = reader[BLUR_EFFECT_NAMES].asArray()
            for (i in 0..ja.size()) {
                let jo: JsonObject = ja[i].asObject()
                let be: BlurEffect = maybeParseInnerEffect(jo, composition)
                ef.append(be)
            }
        }
        return ef
    }

    private static func maybeParseInnerEffect(reader: JsonObject, composition: AnimationData): BlurEffect {

        var blurEffect: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
        var isCorrectType: Int64 = 0
        var isNull: Bool = true

        if (reader.containsKey(INNER_BLUR_EFFECT_NAMES[0])) {//"ty" //"layers"."ef"."ef"."ty"
            isCorrectType = reader[INNER_BLUR_EFFECT_NAMES[0]].asInt().getValue()
        }
        if (reader.containsKey(INNER_BLUR_EFFECT_NAMES[1])) {//"v" //"layers"."ef"."ef"."v"
            blurEffect = AnimatableValueParser.parseArrayFloat(reader[INNER_BLUR_EFFECT_NAMES[1]], composition)
            isNull = false
        }

        return BlurEffect(isCorrectType, ContentModelPK(blurEffect), isNull)
    }
}
