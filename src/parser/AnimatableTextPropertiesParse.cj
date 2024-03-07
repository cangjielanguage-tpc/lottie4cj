/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableTextPropertiesParser {

    //"layers"."t"."a"(."a")
    private static let PROPERTIES_NAMES: String = "a"

    //"layers"."t"."a"."a"(.{"fc", "sc", "sw", "t"})
    private static let ANIMATABLE_PROPERTIES_NAMES: Array<String> = [
        "fc", //0
        "sc", //1
        "sw", //2
        "t"   //3
    ]

    public static func parse(reader: JsonObject): AnimatableTextProperties {
        var anim: AnimatableTextProperties = AnimatableTextProperties()
        if (let Some(v) <- reader.get(PROPERTIES_NAMES)) { //"a"   //"layers"."t"."a"(."a")
            let jo: JsonObject = v.asObject()
            anim = parseAnimatableTextProperties(jo)
        }
        return anim
    }

    private static func parseAnimatableTextProperties(reader: JsonObject): AnimatableTextProperties {
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var stroke: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var strokeWidth: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var tracking: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        //"layers"."t"."a"."a"(.{"fc", "sc", "sw", "t"})
        if (let Some(v) <- reader.get(ANIMATABLE_PROPERTIES_NAMES[0])) { //"fc"
            let jv: JsonValue = v.asObject()
            color = AnimatableValueParser.parseColor(jv)
        }
        if (let Some(v) <- reader.get(ANIMATABLE_PROPERTIES_NAMES[1])) { //"sc"
            let jv: JsonValue = v.asObject()
            stroke = AnimatableValueParser.parseColor(jv)
        }
        if (let Some(v) <- reader.get(ANIMATABLE_PROPERTIES_NAMES[2])) { //"sw"
            let jv: JsonValue = v.asObject()
            strokeWidth = AnimatableValueParser.parseFloat(jv)
        }
        if (let Some(v) <- reader.get(ANIMATABLE_PROPERTIES_NAMES[3])) { //"t"
            let jv: JsonValue = v.asObject()
            tracking = AnimatableValueParser.parseFloat(jv)
        }

        let cm: AnimatableTextProperties = AnimatableTextProperties(
            fc: ArrayKeyframeArrayFloat64(k: color),
            sc: stroke,
            sw: strokeWidth,
            t: ArrayKeyframeFloat64(k: tracking)
        )
        return cm
    }
}
