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

    public static func parse(reader: JsonObject, composition: AnimationData): AnimatableTextProperties {
        var anim: AnimatableTextProperties = AnimatableTextProperties()
        let flag: Bool = reader.containsKey(PROPERTIES_NAMES)
        if (flag) { //"a"   //"layers"."t"."a"(."a")
            let jo: JsonObject = reader[PROPERTIES_NAMES].asObject()
            anim = parseAnimatableTextProperties(jo, composition)
        }
        return anim
    }

    private static func parseAnimatableTextProperties(reader: JsonObject, composition: AnimationData): AnimatableTextProperties {
        var color: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
        var stroke: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
        var strokeWidth: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var tracking: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

        //"layers"."t"."a"."a"(.{"fc", "sc", "sw", "t"})
        if (reader.containsKey(ANIMATABLE_PROPERTIES_NAMES[0])) { //"fc"
            let jv: JsonValue = reader[ANIMATABLE_PROPERTIES_NAMES[0]].asObject()
            color = AnimatableValueParser.parseColor(jv, composition)
        }
        if (reader.containsKey(ANIMATABLE_PROPERTIES_NAMES[1])) { //"sc"
            let jv: JsonValue = reader[ANIMATABLE_PROPERTIES_NAMES[1]].asObject()
            stroke = AnimatableValueParser.parseColor(jv, composition)
        }
        if (reader.containsKey(ANIMATABLE_PROPERTIES_NAMES[2])) { //"sw"
            let jv: JsonValue = reader[ANIMATABLE_PROPERTIES_NAMES[2]].asObject()
            strokeWidth = AnimatableValueParser.parseFloat(jv, composition)
        }
        if (reader.containsKey(ANIMATABLE_PROPERTIES_NAMES[3])) { //"t"
            let jv: JsonValue = reader[ANIMATABLE_PROPERTIES_NAMES[3]].asObject()
            tracking = AnimatableValueParser.parseFloat(jv, composition)
        }

        let cm: AnimatableTextProperties = AnimatableTextProperties()
        cm.fc = color
        cm.sc = stroke
        cm.sw = strokeWidth
        cm.t = tracking
        return cm
    }
}
