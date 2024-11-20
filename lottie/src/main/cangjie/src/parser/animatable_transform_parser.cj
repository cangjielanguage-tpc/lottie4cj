/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimatableTransformParser structure.
 */
package lottie.parser

public class AnimatableTransformParser {

    /**
     * Animate the "ks" data in the json data, parsed into the corresponding AnimatableTransform entity class.
     *
     * @param reader - Type of JsonObject. Animate the "ks" data in json data.
     * @return Type of AnimatableTransform. An instance of the "ks" data that encapsulates the animation.
     */
    public static func parse(reader: JsonReader, types: String): AnimatableTransform {
        var anchorPoint: ArrayKeyframePointF = ArrayKeyframePointF()
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var scale: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64()
        var opacity: ArrayKeyframeInt64 = ArrayKeyframeInt64()

        var rotation: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()

        var startOpacity: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var endOpacity: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var skew: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var skewAngle: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var ty: String = types

        let isObject: Bool = reader.peek() == JsonToken.BeginObject
        if (isObject) {
            reader.startObject()
        }

        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" =>
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "k" => anchorPoint.k = AnimatablePathValueParser.parse(reader)
                            case "a" => anchorPoint.a = reader.readValue<Int64>()
                            case "ix" => anchorPoint.ix = reader.readValue<Int64>()
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                case "p" => position = AnimatablePathValueParser.parseSplitPath(reader)
                case "s" => scale.k = AnimatableValueParser.parseScale(reader)
                case "rz" => logger.log(LogLevel.INFO, "Lottie doesn't support 3D layers.")
                case "r" => rotation.k = AnimatableValueParser.parseFloat(reader)
                case "o" => opacity.k = AnimatableValueParser.parseInteger(reader)
                case "so" => startOpacity.k = AnimatableValueParser.parseFloat(reader)
                case "eo" => endOpacity.k = AnimatableValueParser.parseFloat(reader)
                case "sk" => skew.k = AnimatableValueParser.parseFloat(reader)
                case "sa" => skewAngle.k = AnimatableValueParser.parseFloat(reader)
                case "ty" => ty = reader.readValue<String>()
                case _ => reader.skip()
            }
        }
        if (isObject) {
            reader.endObject()
        }

        return AnimatableTransform(
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
    }
}
