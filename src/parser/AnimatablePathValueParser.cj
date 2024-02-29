/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatablePathValueParser {

    //"layers"."shapes"."p"."k"   <== "layers"."shapes".{"ty": "tr"}  //"k": [0, 0]
    private static let NAMES: Array<String> = [
        "k",
        "x",
        "y"
    ]

    public static func parse(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<PointF>> {
        let keyframes: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray)) {
            let ja: JsonArray = reader.asArray()

            let len: Int64 = ja.size()
            if (len <= 0) {
                return keyframes
            }
            jk = ja[0].kind()
            if (equalsJsonKind(jk, JsonKind.JsInt) || equalsJsonKind(jk, JsonKind.JsFloat)) {
                keyframes.append(PathKeyframeParser.parse(ja, composition))
            } else if (equalsJsonKind(jk, JsonKind.JsObject)) {
                for (i in 0..len) {
                    keyframes.append(PathKeyframeParser.parse(ja[i], composition))
                }
            }
        } else {
            //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
            let scale: Float64 = SCALE_FEFAULT
            keyframes.append(Keyframe<PointF>(JsonUtils.jsonToPoint(reader, scale)))
        }
        return keyframes
    }

    static func parseSplitPath(reader: JsonValue, composition: AnimationData): AnimatableSplitDimensionPathValue {

        var pathAnimation: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var xAnimation: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var yAnimation: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

        var hasExpressions:Bool = false

        let jsonObject: JsonObject = reader.asObject()
        if (jsonObject.containsKey(NAMES[0])) { //"k"
            let jv: JsonValue = jsonObject[NAMES[0]]
            pathAnimation = AnimatablePathValueParser.parse(jv, composition)
        }
        if (jsonObject.containsKey(NAMES[1])) { //"x"
            let jv: JsonValue = jsonObject[NAMES[1]]
            let jk: JsonKind = jv.kind()
            if (equalsJsonKind(jk, JsonKind.JsString)) {
                hasExpressions = true
            } else {
                xAnimation = AnimatableValueParser.parseFloat(jv, composition)
            }
        }
        if (jsonObject.containsKey(NAMES[2])) { //"y"
            let jv: JsonValue = jsonObject[NAMES[2]]
            let jk: JsonKind = jv.kind()
            if (equalsJsonKind(jk, JsonKind.JsString)) {
                hasExpressions = true
            } else {
                yAnimation = AnimatableValueParser.parseFloat(jv, composition)
            }
        }

        if (hasExpressions) {
            composition.addWarning("Lottie doesn't support expressions.")
        }

        let aspv: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        aspv.k = pathAnimation
        aspv.x = xAnimation
        aspv.y = yAnimation
        return aspv
    }
}
