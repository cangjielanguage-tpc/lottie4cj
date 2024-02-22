/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableTransformParser {

    private static let NAMES: Array<String> = [
        "a",  // 0
        "p",  // 1
        "s",  // 2
        "rz", // 3
        "r",  // 4
        "o",  // 5
        "so", // 6
        "eo", // 7
        "sk", // 8
        "sa"  // 9
    ]
    private static let ANIMATABLE_NAMES: String = "k"

    public static func parse(jsonObject: JsonObject, composition: AnimationData): AnimatableTransform {

        var anchorPoint: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var scale: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
        var opacity: ArrayList<Keyframe<Int64>> = ArrayList<Keyframe<Int64>>()

        var rotation: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var startOpacity: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var endOpacity: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var skew: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var skewAngle: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

        if (jsonObject.containsKey(NAMES[0])) { // "a"
            let jo: JsonObject = jsonObject[NAMES[0]].asObject()
            if (jo.containsKey(ANIMATABLE_NAMES)) { //"k"
                let jv: JsonValue = jo[ANIMATABLE_NAMES]
                anchorPoint = AnimatablePathValueParser.parse(jv, composition)
            }
        }
        if (jsonObject.containsKey(NAMES[1])) { // "p"
            let jv: JsonValue = jsonObject[NAMES[1]]
            position = AnimatablePathValueParser.parseSplitPath(jv, composition)
        }

        if (jsonObject.containsKey(NAMES[2])) { //  "s"
            let jv: JsonValue = jsonObject[NAMES[2]]
            scale = AnimatableValueParser.parseScale(jv, composition)
        }

        if (jsonObject.containsKey(NAMES[4])) { //  r
              let jv: JsonValue = jsonObject[NAMES[4]]
              rotation = AnimatableValueParser.parseFloat(jv, composition, false)
        }
        if (jsonObject.containsKey(NAMES[5])) { //  o
            let jv: JsonValue = jsonObject[NAMES[5]]
            opacity = AnimatableValueParser.parseInteger(jv, composition)
        }
        if (jsonObject.containsKey(NAMES[6])) { //  "so"
            let jv: JsonValue = jsonObject[NAMES[2]]
            startOpacity = AnimatableValueParser.parseFloat(jv, composition, false)
        }
        if (jsonObject.containsKey(NAMES[7])) { //  "eo"
            let jv: JsonValue = jsonObject[NAMES[7]]
            endOpacity = AnimatableValueParser.parseFloat(jv, composition, false)
        }
        if (jsonObject.containsKey(NAMES[8])) { //  "sk"
            let jv: JsonValue = jsonObject[NAMES[8]]
            skew = AnimatableValueParser.parseFloat(jv, composition, false)
        }
        if (jsonObject.containsKey(NAMES[9])) { //  "sa"
            let jv: JsonValue = jsonObject[NAMES[9]]
            skewAngle = AnimatableValueParser.parseFloat(jv, composition, false)
        }

        let cm: AnimatableTransform = AnimatableTransform()
        cm.a = anchorPoint
        cm.p = position
        cm.s = scale
        cm.r = rotation
        cm.o = opacity
        cm.so = startOpacity
        cm.eo = endOpacity
        cm.sk = skew
        cm.sa = skewAngle
        return cm
    }

}
