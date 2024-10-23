/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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
    public static func parseFloat(reader: JsonValue): Array<Keyframe<Float64>> {
        return parse(reader, FloatParser.INSTANCE)
    }

    /**
     * Animate the specified data in the json data,
     * parsed and encapsulated into the corresponding Keyframe<Array<Float64>> in an array of instances.
     *
     * @param reader - Type of JsonValue. Animate the specified data in the json data.
     * @return Type of Array<Keyframe<Array<Float64>>>.
     *                 An array of instances of the specified data that encapsulates the animation.
     */
    public static func parseArrayFloat(reader: JsonValue): Array<Keyframe<Array<Float64>>> {
        return parse(reader, ArrayFloat64Parser.INSTANCE)
    }

    static func parseInteger(reader: JsonValue): Array<Keyframe<Int64>> {
        return parse(reader, IntegerParser.INSTANCE)
    }

    static func parsePoint(reader: JsonValue): Array<Keyframe<PointF>> {
        return KeyframesParser.parse(reader, PointFParser.INSTANCE)
    }

    static func parseScale(reader: JsonValue): Array<Keyframe<Array<Float64>>> {
        return parse(reader, ScaleXYParser.INSTANCE)
    }

    static func parseShapeData(reader: JsonValue): Array<Keyframe<ShapeData>> {
        return parse(reader, ShapeDataParser.INSTANCE)
    }

    static func parseDocumentData(reader: JsonValue): Array<Keyframe<DocumentData>> {
        return parse(reader, DocumentDataParser.INSTANCE)
    }

    static func parseColor(reader: JsonValue): Array<Keyframe<Array<Float64>>> {
        return parse(reader, ColorParser.INSTANCE)
    }

    static func parseGradientColor(reader: JsonValue, points: Int64): Array<Keyframe<Array<Float64>>> {
        return parse(reader, GradientColorParser(points))
    }

    private static func parse<T>(reader: JsonValue, valueParser: ValueParser<T>): Array<Keyframe<T>> where T <: ToString {
        return KeyframesParser.parse<T>(reader, valueParser)
    }
}
