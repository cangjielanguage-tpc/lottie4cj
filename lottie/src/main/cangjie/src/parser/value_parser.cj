/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

internal import encoding.json.stream.JsonReader
internal import encoding.json.stream.JsonToken
internal import lottie.model.*
internal import std.collection.*
internal import std.log.*

public interface ValueParser<T> {
    func parse(reader: JsonReader): T
}

public class IntegerParser <: ValueParser<Int64> {

    /**
     * Get IntegerParser instance.
     *
     * @return IntegerParser instance.
     */
    public static let INSTANCE: IntegerParser = IntegerParser()

    private init() {}

    /**
     * Animate the specified data in the json data, parsed to a numerical value.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Int64. Parse as a numerical value.
     */
    @OverflowWrapping
    public func parse(reader: JsonReader): Int64 {
        return Int64(round(JsonUtils.valueFromObject(reader)))
    }
}

public class FloatParser <: ValueParser<Float64> {

    /**
     * Get FloatParser instance.
     *
     * @return FloatParser instance.
     */
    public static let INSTANCE: FloatParser = FloatParser()

    private init() {}

    /**
     * Animate the specified data in the json data, parsed to a numerical value.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Float64. Parse as a numerical value.
     */
    public func parse(reader: JsonReader): Float64 {
        return JsonUtils.valueFromObject(reader)
    }
}

public class ScaleXYParser <: ValueParser<Array<Float64>> {
    /**
     * Get ScaleXYParser instance.
     *
     * @return ScaleXYParser instance.
     */
    public static let INSTANCE: ScaleXYParser = ScaleXYParser()
    init() {}

    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonReader): Array<Float64> {
        match (reader.peek()) {
            case Some(JsonToken.JsonNumber) =>
                var sList: ArrayList<Float64> = ArrayList<Float64>()
                while (reader.peek() != EndArray) {
                    sList.append(reader.readValue<Float64>())
                }
                return sList.toArray()
            case Some(JsonToken.BeginArray) => reader.readValue<Array<Float64>>()
            case _ => throw IllegalArgumentException("Invalid scale value")
        }
    }
}

public class ArrayFloat64Parser <: ValueParser<Array<Float64>> {
    /**
     * Get ArrayFloat64Parser instance.
     *
     * @return ArrayFloat64Parser instance.
     */
    public static let INSTANCE: ArrayFloat64Parser = ArrayFloat64Parser()
    init() {}

    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonReader): Array<Float64> {
        if (reader.peek() == JsonToken.BeginArray) {
            return reader.readValue<Array<Float64>>()
        } else {
            return [reader.readValue<Float64>()]
        }
    }
}

public class PointFParser <: ValueParser<PointF> {
    /**
     * Get PointFParser instance.
     *
     * @return PointFParser instance.
     */
    public static let INSTANCE: PointFParser = PointFParser()

    private PointFParser() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of PointF. The parsing is encapsulated in this entity class.
     */
    public func parse(reader: JsonReader): PointF {
        match (reader.peek()) {
            case Some(JsonToken.BeginArray) => return JsonUtils.jsonToPoint(reader)
            case Some(JsonToken.BeginObject) => return JsonUtils.jsonToPoint(reader)
            case Some(JsonToken.JsonNumber) =>
                let point = PointF(x: reader.readValue<Float64>(), y: reader.readValue<Float64>())
                while (reader.peek() != EndArray) {
                    reader.skip()
                }
                return point
            case _ => throw IllegalArgumentException(
                "Cannot convert json to point. Next token is not array and object.")
        }
    }
}

public class DocumentDataParser <: ValueParser<DocumentData> {
    /**
     * Get DocumentDataParser instance.
     *
     * @return DocumentDataParser instance.
     */
    public static let INSTANCE: DocumentDataParser = DocumentDataParser()

    private init() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of DocumentData. The parsing is encapsulated in this entity class.
     */
    public func parse(reader: JsonReader): DocumentData {
        var text: String = ""
        var fontName: String = ""
        var size: Float64 = 0.0
        var justification: Int64 = 0
        var tracking: Int64 = 0
        var lineHeight: Float64 = 0.0
        var baselineShift: Float64 = 0.0

        var fillColor: Array<Float64> = Array<Float64>()
        var strokeColor: Array<Float64> = Array<Float64>()

        var strokeWidth: Float64 = 0.0
        var strokeOverFill: Bool = false

        var boxPosition = ArrayList<Float64>(4)
        var boxSize = ArrayList<Float64>(4)

        reader.startObject()
        while (reader.peek() == JsonToken.Name) {
            match (reader.readName()) {
                case "t" => text = reader.readValue<String>()
                case "f" => fontName = reader.readValue<String>()
                case "s" => size = reader.readValue<Float64>()
                case "j" => justification = reader.readValue<Int64>()
                case "tr" => tracking = reader.readValue<Int64>()
                case "lh" => lineHeight = reader.readValue<Float64>()
                case "ls" => baselineShift = reader.readValue<Float64>()
                case "fc" => fillColor = JsonUtils.jsonToColor(reader)
                case "sc" => strokeColor = JsonUtils.jsonToColor(reader)
                case "sw" => strokeWidth = reader.readValue<Float64>()
                case "of" => strokeOverFill = reader.readValue<Bool>()
                case "ps" =>
                    reader.startArray()
                    while (reader.peek() != JsonToken.EndArray) {
                        boxPosition.append(reader.readValue<Float64>())
                    }
                    reader.endArray()
                case "sz" =>
                    reader.startArray()
                    while (reader.peek() != JsonToken.EndArray) {
                        boxSize.append(reader.readValue<Float64>())
                    }
                    reader.endArray()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return DocumentData(
            t: text,
            f: fontName,
            s: size,
            j: justification,
            tr: tracking,
            lh: lineHeight,
            ls: baselineShift,
            fc: fillColor,
            sc: strokeColor,
            sw: strokeWidth,
            of: strokeOverFill,
            ps: boxPosition.toArray(),
            sz: boxSize.toArray()
        )
    }
}
