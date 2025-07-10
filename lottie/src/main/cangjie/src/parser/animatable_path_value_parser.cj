/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimatablePathValueParser structure.
 */
package lottie.parser

internal import ohos.hilog.Hilog

public class AnimatablePathValueParser {
    public static func parse(reader: JsonReader): Array<Keyframe<PointF>> {
        let keyframes = ArrayList<Keyframe<PointF>>()
        if (reader.peek() == JsonToken.BeginArray) {
            reader.startArray()
            while (reader.peek() != JsonToken.EndArray) {
                keyframes.add(PathKeyframeParser.parse(reader))
            }
            reader.endArray()
        } else {
            keyframes.add(Keyframe<PointF>(k: JsonUtils.jsonToPoint(reader)))
        }
        // Once extra memory copy
        return keyframes.toArray()
    }

    static func parseSplitPath(reader: JsonReader): AnimatableSplitDimensionPathValue {
        var a: Int64 = 0
        var ix: Int64 = 0
        var s: Bool = false

        var pathAnimation: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>()
        var xAnimation: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
        var yAnimation: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        var hasExpressions: Bool = false

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" => a = reader.readValue<Int64>()
                case "ix" => ix = reader.readValue<Int64>()
                case "s" => s = reader.readValue<Bool>()
                case "k" => pathAnimation = AnimatablePathValueParser.parse(reader)
                case "x" => if (reader.peek() == JsonToken.JsonString) {
                    hasExpressions = true
                    reader.skip()
                } else {
                    xAnimation = AnimatableValueParser.parseFloat(reader)
                }
                case "y" => if (reader.peek() == JsonToken.JsonString) {
                    hasExpressions = true
                    reader.skip()
                } else {
                    yAnimation = AnimatableValueParser.parseFloat(reader)
                }
                case _ => reader.skip()
            }
        }
        reader.endObject()

        if (hasExpressions) {
            Hilog.info(0, "[AnimatablePathValueParser]","Lottie doesn't support expressions.")
        }

        return AnimatableSplitDimensionPathValue(
            a: a,
            ix: ix,
            s: s,
            k: pathAnimation,
            x: xAnimation,
            y: yAnimation
        )
    }
}
