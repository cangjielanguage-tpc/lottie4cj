/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class AnimatableValueParser {

    public static func parseFloat(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<Float64>> {
        return parseFloat(reader, composition, true)
    }

    public static func parseFloat(reader: JsonValue, composition: AnimationData, isDp: Bool): ArrayList<Keyframe<Float64>> {
        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        var scale: Float64 = 1.0
        return parse(reader, scale, composition, FloatParser.INSTANCE)
    }

    public static func parseArrayFloat(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<Array<Float64>>> {
        return parseArrayFloat(reader, composition, true)
    }

    public static func parseArrayFloat(reader: JsonValue, composition: AnimationData, isDp: Bool): ArrayList<Keyframe<Array<Float64>>> {
        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        var scale: Float64 = 1.0
        return parse(reader, scale, composition, ArrayFloat64Parser.INSTANCE)
    }

    static func parseInteger(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<Int64>> {
        let res: ArrayList<Keyframe<Int64>> = parse(reader, composition, IntegerParser.INSTANCE)
        return res
    }

    static func parsePoint(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<PointF>> {
        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        var scale: Float64 = 1.0
        let res: ArrayList<Keyframe<PointF>> = KeyframesParser.parse(reader, composition, scale, PointFParser.INSTANCE, true)
        return res
    }

    static func parseScale(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<Array<Float64>>> {
        let scaleValue: ArrayList<Keyframe<Array<Float64>>> = parse(reader, composition, ScaleXYParser.INSTANCE)
        return scaleValue
    }

    static func parseShapeData(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<ShapeData>> {
        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        var scale: Float64 = 1.0
        let sd: ArrayList<Keyframe<ShapeData>> = parse(reader, scale, composition, ShapeDataParser.INSTANCE)
        return sd
    }

    static func parseDocumentData(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<DocumentData>> {
        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        var scale: Float64 = 1.0
        let dd: ArrayList<Keyframe<DocumentData>> = parse(reader, scale, composition, DocumentDataParser.INSTANCE)
        return dd
    }

    static func parseColor(reader: JsonValue, composition: AnimationData): ArrayList<Keyframe<Array<Float64>>> {
        let dd: ArrayList<Keyframe<Array<Float64>>> = parse(reader, composition, ColorParser.INSTANCE)
        return dd
    }

    static func parseGradientColor(reader: JsonValue, composition: AnimationData, points: Int64): ArrayList<Keyframe<Array<Float64>>> {
        let gradientColorValue: ArrayList<Keyframe<Array<Float64>>> = parse(reader, composition, GradientColorParser(points))
        return gradientColorValue
    }

    private static func parse<T>(reader: JsonValue, composition: AnimationData, valueParser: ValueParser<T>): ArrayList<Keyframe<T>> where T <: ToString {
        return KeyframesParser.parse<T>(reader, composition, 1.0, valueParser, false)
    }

    private static func parse<T>(reader: JsonValue, scale: Float64, composition: AnimationData, valueParser: ValueParser<T>): ArrayList<Keyframe<T>> where T <: ToString {
        return KeyframesParser.parse<T>(reader, composition, scale, valueParser, false)
    }
}
