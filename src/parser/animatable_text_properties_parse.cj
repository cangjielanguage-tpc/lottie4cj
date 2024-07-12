/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTextPropertiesParser structure.
 */
package parser

public class AnimatableTextPropertiesParser {

    //"layers"."t"."a"(."a")
    private static let PROPERTIES_NAMES: Array<String> = ["a", "s"]

    //"layers"."t"."a"."a"(.{"fc", "sc", "sw", "t"})
    private static let ANIMATABLE_PROPERTIES_NAMES: Array<String> = [
        "fc", //0
        "sc", //1
        "sw", //2
        "t"   //3
    ]

    private static let PROPERTIES_NAMES_S: Array<String> = [
        "t",  //0
        "xe", //1
        "ne", //2
        "a",  //3
        "b",  //4
        "rn", //5
        "sh", //6
        "r"   //7
    ]

    private static let PROPERTIES_NAMES_S_AK: Array<String> = [
        "a",  //0
        "k"   //1
    ]

    /**
     * Animate the data of a special "a" in json data, parsed into the corresponding AnimatableTextProperties instance.
     *
     * @param reader - Type of JsonObject. Animate special "a" data in json data.
     * @return Type of AnimatableTextProperties.
     *                 an array of instances of the special "a" data that encapsulates the animation.
     */
    public static func parse(reader: JsonObject): AnimatableTextPropertiesA {
        var anim: AnimatableTextProperties = AnimatableTextProperties()
        if (let Some(v) <- reader.get(PROPERTIES_NAMES[0])) { //"a"   //"layers"."t"."a"(."a")
            let jo: JsonObject = v.asObject()
            anim = parseAnimatableTextProperties(jo)
        }
        var s: AnimatableTextPropertiesS = AnimatableTextPropertiesS()
        if (let Some(v) <- reader.get(PROPERTIES_NAMES[1])) { //"s"   //"layers"."t"."a"(."s")
            let jo: JsonObject = v.asObject()
            s = parseS(jo)
        }
        return AnimatableTextPropertiesA(a: anim, s: s)
    }

    private static func parseS(jo: JsonObject): AnimatableTextPropertiesS {
        var t: Int64 = 0
        var xe: AK = AK()
        var ne: AK = AK()
        var a: AK = AK()
        var b: Int64 = 0
        var rn: Int64 = 0
        var sh: Int64 = 0
        var r: Int64 = 0
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[0])) { //"t"
            t = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[1])) { //"xe"
            let jo: JsonObject = v.asObject()
            xe = parseSAK(jo)
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[2])) { //"ne"
            let jo: JsonObject = v.asObject()
            ne = parseSAK(jo)
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[3])) { //"a"
            let jo: JsonObject = v.asObject()
            a = parseSAK(jo)
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[4])) { //"b"
            b = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[5])) { //"rn"
            rn = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[6])) { //"sh"
            sh = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S[7])) { //"r"
            r = v.asInt().getValue()
        }
        return AnimatableTextPropertiesS(t: t, xe: xe, ne: ne, a: a, b: b, rn: rn, sh: sh, r: r)
    }

    private static func parseSAK(jo: JsonObject): AK {
        var a: Int64 = 0
        var k: Int64 = 0
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S_AK[0])) { //"a"
            a = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(PROPERTIES_NAMES_S_AK[1])) { //"k"
            k = v.asInt().getValue()
        }
        return AK(a: a, k: k)
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
