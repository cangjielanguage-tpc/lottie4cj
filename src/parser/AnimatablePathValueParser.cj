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

    public static func parse(reader: JsonValue): Array<Keyframe<PointF>> {
        var keyframes: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray)) {
            let ja: JsonArray = reader.asArray()

            let len: Int64 = ja.size()
            if (len <= 0) {
                return keyframes
            }
            jk = ja[0].kind()
            if (equalsJsonKind(jk, JsonKind.JsInt) || equalsJsonKind(jk, JsonKind.JsFloat)) {
                keyframes = [PathKeyframeParser.parse(ja)]
            } else if (equalsJsonKind(jk, JsonKind.JsObject)) {
                let EMPTY_KEYFRAME_POINTF: Keyframe<PointF> = Keyframe<PointF>()
                keyframes = Array<Keyframe<PointF>>(len, item: EMPTY_KEYFRAME_POINTF)
                for (i in 0..len) {
                    keyframes[i] = PathKeyframeParser.parse(ja[i])
                }
            }
        } else {
            keyframes = [Keyframe<PointF>(k: JsonUtils.jsonToPoint(reader))]
        }
        return keyframes
    }

    static func parseSplitPath(reader: JsonValue): AnimatableSplitDimensionPathValue {

        var pathAnimation: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var xAnimation: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var yAnimation: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        var hasExpressions:Bool = false

        let jsonObject: JsonObject = reader.asObject()
        if (let Some(v) <- jsonObject.get(NAMES[0])) { //"k"
            pathAnimation = AnimatablePathValueParser.parse(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[1])) { //"x"
            let jk: JsonKind = v.kind()
            if (equalsJsonKind(jk, JsonKind.JsString)) {
                hasExpressions = true
            } else {
                xAnimation = AnimatableValueParser.parseFloat(v)
            }
        }
        if (let Some(v) <- jsonObject.get(NAMES[2])) { //"y"
            let jk: JsonKind = v.kind()
            if (equalsJsonKind(jk, JsonKind.JsString)) {
                hasExpressions = true
            } else {
                yAnimation = AnimatableValueParser.parseFloat(v)
            }
        }

        if (hasExpressions) {
            logger.log(LogLevel.INFO,  "Lottie doesn't support expressions.")
        }

        let aspv: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(
            k: pathAnimation,
            x: xAnimation,
            y: yAnimation
        )
        return aspv
    }
}
