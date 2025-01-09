/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimatableTextPropertiesParser structure.
 */
package lottie.parser

public class AnimatableTextPropertiesParser {

    /**
     * Animate the data of a special "a" in json data, parsed into the corresponding AnimatableTextProperties instance.
     *
     * @param reader - Type of JsonObject. Animate special "a" data in json data.
     * @return Type of AnimatableTextProperties.
     *                 an array of instances of the special "a" data that encapsulates the animation.
     */
    public static func parse(reader: JsonReader): AnimatableTextPropertiesA {
        var anim: AnimatableTextProperties = AnimatableTextProperties()
        var s: AnimatableTextPropertiesS = AnimatableTextPropertiesS()
        reader.startObject()
        while (reader.peek() != JsonToken.EndObject) {
            match (reader.readName()) {
                case "a" => anim = parseAnimatableTextProperties(reader)
                case "s" => s = parseS(reader)
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return AnimatableTextPropertiesA(a: anim, s: s)
    }

    private static func parseS(reader: JsonReader): AnimatableTextPropertiesS {
        var t: Int64 = 0
        var xe: AK = AK()
        var ne: AK = AK()
        var a: AK = AK()
        var b: Int64 = 0
        var rn: Int64 = 0
        var sh: Int64 = 0
        var r: Int64 = 0
        var scale: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()
        var scalee: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()
        var scaleo: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "t" => t = reader.readValue<Int64>()
                case "xe" => xe = parseSAK(reader)
                case "ne" => ne = parseSAK(reader)
                case "a" => a = parseSAK(reader)
                case "b" => b = reader.readValue<Int64>()
                case "rn" => rn = reader.readValue<Int64>()
                case "sh" => sh = reader.readValue<Int64>()
                case "s" =>
                    scale.k = AnimatableValueParser.parseScale(reader)
                case "e" => scalee.k = AnimatableTextPropertiesParser.ArrayKeyframeArrayFloat64Parser(reader)
                case "o" => scaleo.k = AnimatableValueParser.parseScale(reader)
                case "r" => r = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return AnimatableTextPropertiesS(t: t, xe: xe, ne: ne, a: a, b: b, rn: rn, sh: sh, r: r, s: scale, e: scalee, o: scaleo)
    }

    public static func ArrayKeyframeArrayFloat64Parser(reader: JsonReader): Array<Keyframe<Array<Float64>>> {
        var keyframes = ArrayList<Keyframe<Array<Float64>>>()

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "k" => if (reader.peek() == JsonToken.BeginArray) {
                    reader.startArray()
                    if (reader.peek() == JsonToken.BeginObject) {
                        while (reader.peek() != JsonToken.EndArray) {
                            keyframes.append(KeyframeParser.parseKeyframe<Array<Float64>>(reader, ScaleXYParser.INSTANCE))
                        }
                    }
                    reader.endArray()
                } else if (reader.peek() == JsonToken.JsonNumber) {
                    var scc = Keyframe<Array<Float64>>()
                    scc.k = [Float64(reader.readValue<Int64>())]
                    keyframes.append(scc)
                }
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return keyframes.toArray()
    }

    private static func parseSAK(reader: JsonReader): AK {
        var a: Int64 = 0
        var k: Int64 = 0
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" => a = reader.readValue<Int64>()
                case "k" => k = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return AK(a: a, k: k)
    }

    private static func parseAnimatableTextProperties(reader: JsonReader): AnimatableTextProperties {
        var scolor: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var color: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var stroke: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var strokeWidth: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var tracking: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        //"layers"."t"."a"."a"(.{"fc", "sc", "sw", "t"})
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "s" => scolor = AnimatableValueParser.parseColor(reader)
                case "fc" => color = AnimatableValueParser.parseColor(reader)
                case "sc" => stroke = AnimatableValueParser.parseColor(reader)
                case "sw" => strokeWidth = AnimatableValueParser.parseFloat(reader)
                case "t" => tracking = AnimatableValueParser.parseFloat(reader)
                case _ => reader.skip()
            }
        }
        reader.endObject()

        let cm: AnimatableTextProperties = AnimatableTextProperties(
            fc: ArrayKeyframeArrayFloat64(k: color),
            s: ArrayKeyframeArrayFloat64(k: scolor),
            sc: stroke,
            sw: strokeWidth,
            t: ArrayKeyframeFloat64(k: tracking)
        )
        return cm
    }
}
