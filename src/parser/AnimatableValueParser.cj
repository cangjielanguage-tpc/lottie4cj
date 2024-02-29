/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableValueParser {

    public static func parseFloat(reader: JsonValue): ArrayList<Keyframe<Float64>> {
        return parse(reader, FloatParser.INSTANCE)
    }

    public static func parseArrayFloat(reader: JsonValue): ArrayList<Keyframe<Array<Float64>>> {
        return parse(reader, ArrayFloat64Parser.INSTANCE)
    }

    static func parseInteger(reader: JsonValue): ArrayList<Keyframe<Int64>> {
        return parse(reader, IntegerParser.INSTANCE)
    }

    static func parsePoint(reader: JsonValue): ArrayList<Keyframe<PointF>> {
        return KeyframesParser.parse(reader, PointFParser.INSTANCE)
    }

    static func parseScale(reader: JsonValue): ArrayList<Keyframe<Array<Float64>>> {
        return parse(reader, ScaleXYParser.INSTANCE)
    }

    static func parseShapeData(reader: JsonValue): ArrayList<Keyframe<ShapeData>> {
        return parse(reader, ShapeDataParser.INSTANCE)
    }

    static func parseDocumentData(reader: JsonValue): ArrayList<Keyframe<DocumentData>> {
        return parse(reader, DocumentDataParser.INSTANCE)
    }

    static func parseColor(reader: JsonValue): ArrayList<Keyframe<Array<Float64>>> {
        return parse(reader, ColorParser.INSTANCE)
    }

    static func parseGradientColor(reader: JsonValue, points: Int64): ArrayList<Keyframe<Array<Float64>>> {
        return parse(reader, GradientColorParser(points))
    }

    private static func parse<T>(reader: JsonValue, valueParser: ValueParser<T>): ArrayList<Keyframe<T>> where T <: ToString {
        return KeyframesParser.parse<T>(reader, valueParser)
    }
}
