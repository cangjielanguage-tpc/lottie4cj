/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimatableValueParser structure.
 */
package lottie.parser

public class AnimatableValueParser {

    /**
     * Animate the specified data in the json data,
     * parsed and encapsulated into the corresponding Keyframe<Float64> in an array of instances.
     *
     * @param reader - Type of JsonValue. Animate the specified data in the json data.
     * @return Type of Array<Keyframe<Float64>>.
     *                 An array of instances of the specified data that encapsulates the animation.
     */
    public static func parseFloat(reader: JsonReader): Array<Keyframe<Float64>> {
        return parse<Float64>(reader, FloatParser.INSTANCE)
    }

    /**
     * Animate the specified data in the json data,
     * parsed and encapsulated into the corresponding Keyframe<Array<Float64>> in an array of instances.
     *
     * @param reader - Type of JsonValue. Animate the specified data in the json data.
     * @return Type of Array<Keyframe<Array<Float64>>>.
     *                 An array of instances of the specified data that encapsulates the animation.
     */
    public static func parseArrayFloat(reader: JsonReader): Array<Keyframe<Array<Float64>>> {
        return parse<Array<Float64>>(reader, ArrayFloat64Parser.INSTANCE)
    }

    static func parseInteger(reader: JsonReader): Array<Keyframe<Int64>> {
        return parse<Int64>(reader, IntegerParser.INSTANCE)
    }

    static func parsePoint(reader: JsonReader): Array<Keyframe<PointF>> {
        return KeyframesParser.parse(reader, PointFParser.INSTANCE)
    }

    static func parseScale(reader: JsonReader): Array<Keyframe<Array<Float64>>> {
        return parse(reader, ScaleXYParser.INSTANCE)
    }

    static func parseShapeData(reader: JsonReader): Array<Keyframe<ShapeData>> {
        return parse(reader, ShapeDataParser.INSTANCE)
    }

    static func parseDocumentData(reader: JsonReader): Array<Keyframe<DocumentData>> {
        return parse(reader, DocumentDataParser.INSTANCE)
    }

    static func parseColor(reader: JsonReader): Array<Keyframe<Array<Float64>>> {
        return parse<Array<Float64>>(reader, ColorParser.INSTANCE)
    }

    static func parseGradientColor(reader: JsonReader, points: Int64): Array<Keyframe<Array<Float64>>> {
        return parse(reader, GradientColorParser(points))
    }

    /**
     * Will return null if the animation can't be played such as if it has expressions.
     */
    private static func parse<T>(reader: JsonReader, valueParser: ValueParser<T>): Array<Keyframe<T>> where T <: ToString {
        return KeyframesParser.parse<T>(reader, valueParser)
    }
}
