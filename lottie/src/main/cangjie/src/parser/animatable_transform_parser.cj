/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTransformParser structure.
 */
package lottie.parser

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

    private static let NAMES_AIX: Array<String> = [
        "a",  // 0
        "ix"  // 1
    ]

    /**
     * Animate the "ks" data in the json data, parsed into the corresponding AnimatableTransform entity class.
     *
     * @param reader - Type of JsonObject. Animate the "ks" data in json data.
     * @return Type of AnimatableTransform. An instance of the "ks" data that encapsulates the animation.
     */
    public static func parse(jsonObject: JsonObject): AnimatableTransform {
        var anchorPoint: ArrayKeyframePointF = ArrayKeyframePointF()
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var scale: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()
        var opacity: ArrayKeyframeInt64 = ArrayKeyframeInt64()

        var rotation: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        
        var startOpacity: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var endOpacity: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var skew: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var skewAngle: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var ty: String = ""

        if (let Some(v) <- jsonObject.get(NAMES[0])) { // "a"
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(ANIMATABLE_NAMES)) {//"k"
                anchorPoint.k = AnimatablePathValueParser.parse(k)
            }

            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                anchorPoint.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                anchorPoint.ix = k.asInt().getValue()
            }
        }
        if (let Some(v) <- jsonObject.get(NAMES[1])) { // "p"
            position = AnimatablePathValueParser.parseSplitPath(v)
        }

        if (let Some(v) <- jsonObject.get(NAMES[2])) { //  "s"
            scale.k = AnimatableValueParser.parseScale(v)
            
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                scale.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                scale.ix = k.asInt().getValue()
            }
        }
        
        if (jsonObject.containsKey(NAMES[3])) { // "rz"
            logger.log(LogLevel.INFO,  "Lottie doesn't support 3D layers.")
        }

        if (let Some(v) <- jsonObject.get(NAMES[4])) { //  r
            rotation.k = AnimatableValueParser.parseFloat(v)
            
            handleAIX(v, rotation)
        }
        if (let Some(v) <- jsonObject.get(NAMES[5])) { //  o
            opacity.k = AnimatableValueParser.parseInteger(v)
            
            let jo: JsonObject = v.asObject()
            if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
                startOpacity.a = k.asInt().getValue()
            }
            if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
                startOpacity.ix = k.asInt().getValue()
            }
        }
        if (let Some(v) <- jsonObject.get(NAMES[6])) { //  "so"
            startOpacity.k = AnimatableValueParser.parseFloat(v)
            
            handleAIX(v, startOpacity)
        }
        if (let Some(v) <- jsonObject.get(NAMES[7])) { //  "eo"
            endOpacity.k = AnimatableValueParser.parseFloat(v)
            
            handleAIX(v, endOpacity)
        }
        if (let Some(v) <- jsonObject.get(NAMES[8])) { //  "sk"
            skew.k = AnimatableValueParser.parseFloat(v)
            
            handleAIX(v, skew)
        }
        if (let Some(v) <- jsonObject.get(NAMES[9])) { //  "sa"
            skewAngle.k = AnimatableValueParser.parseFloat(v)
            
            handleAIX(v, skewAngle)
        }
        if (let Some(v) <- jsonObject.get(NAMES[10])) { //  "ty"
            ty = v.asString().getValue()
        }

        let cm: AnimatableTransform = AnimatableTransform(
            a: anchorPoint,
            p: position,
            s: scale,
            r: rotation,
            o: opacity,
            so: startOpacity,
            eo: endOpacity,
            sk: skew,
            sa: skewAngle,
            ty: ty
        )
        return cm
    }

    private static func handleAIX(jv: JsonValue, keyframe: ArrayKeyframeFloat64): Unit {
        let jo: JsonObject = jv.asObject()
        if (let Some(k) <- jo.get(NAMES_AIX[0])) { // "a"
            keyframe.a = k.asInt().getValue()
        }
        if (let Some(k) <- jo.get(NAMES_AIX[1])) { // "ix"
            keyframe.ix = k.asInt().getValue()
        }
    }

}
