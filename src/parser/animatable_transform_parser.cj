/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTransformParser structure.
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
        "sa", // 9
        "ty" // 10
    ]
    private static let ANIMATABLE_NAMES: String = "k"

    /**
     * Animate the "ks" data in the json data, parsed into the corresponding AnimatableTransform entity class.
     *
     * @param reader - Type of JsonObject. Animate the "ks" data in json data.
     * @return Type of AnimatableTransform. An instance of the "ks" data that encapsulates the animation.
     */
    public static func parse(jsonObject: JsonObject): AnimatableTransform {
        var anchorPoint: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var scale: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var opacity: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()

        let EMPTY_KFF64: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var rotation: Array<Keyframe<Float64>> = EMPTY_KFF64
        var startOpacity: Array<Keyframe<Float64>> = EMPTY_KFF64
        var endOpacity: Array<Keyframe<Float64>> = EMPTY_KFF64
        var skew: Array<Keyframe<Float64>> = EMPTY_KFF64
        var skewAngle: Array<Keyframe<Float64>> = EMPTY_KFF64
        var ty: String = ""

        if (let Some(v) <- jsonObject.get(NAMES[0])) { // "a"
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(ANIMATABLE_NAMES)) {//"k"
                anchorPoint = AnimatablePathValueParser.parse(k)
            }
        }
        if (let Some(v) <- jsonObject.get(NAMES[1])) { // "p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }

        if (let Some(v) <- jsonObject.get(NAMES[2])) { //  "s"
            scale = AnimatableValueParser.parseScale(v)
        }
        
        if (jsonObject.containsKey(NAMES[3])) { // "rz"
            logger.log(LogLevel.INFO,  "Lottie doesn't support 3D layers.")
        }

        if (let Some(v) <- jsonObject.get(NAMES[4])) { //  r
              rotation = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[5])) { //  o
            opacity = AnimatableValueParser.parseInteger(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[6])) { //  "so"
            startOpacity = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[7])) { //  "eo"
            endOpacity = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[8])) { //  "sk"
            skew = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[9])) { //  "sa"
            skewAngle = AnimatableValueParser.parseFloat(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[10])) { //  "ty"
            ty = v.asString().getValue()
        }

        let cm: AnimatableTransform = AnimatableTransform(
            a: anchorPoint,
            p: position,
            s: scale,
            r: ArrayKeyframeFloat64(k: rotation),
            o: opacity,
            so: startOpacity,
            eo: endOpacity,
            sk: skew,
            sa: skewAngle,
            ty: ty
        )
        return cm
    }

}
