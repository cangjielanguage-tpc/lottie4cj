/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

public class ShapeDataParser <: ValueParser<ShapeData> {
    /**
     * Get ShapeDataParser instance.
     *
     * @return ShapeDataParser instance.
     */
    public static let INSTANCE: ShapeDataParser = ShapeDataParser()

    let defaultPointF = Array<PointF>()
    public func parse(reader: JsonReader): ShapeData {
        if (reader.peek() == JsonToken.BeginArray) {
            reader.startArray()
        }
        var closed: Bool = false
        var pointsArray: Array<PointF> = defaultPointF
        var inTangents: Array<PointF> = defaultPointF
        var outTangents: Array<PointF> = defaultPointF

        var hasv: Bool = false
        var hasi: Bool = false
        var haso: Bool = false
        reader.startObject()
        while (reader.peek() != JsonToken.EndObject) {
            match (reader.readName()) {
                case "c" => closed = reader.readValue<Bool>()
                case "v" =>
                    pointsArray = JsonUtils.jsonToPoints(reader)
                    hasv = true
                case "i" =>
                    inTangents = JsonUtils.jsonToPoints(reader)
                    hasi = true
                case "o" =>
                    outTangents = JsonUtils.jsonToPoints(reader)
                    haso = true
                case _ => reader.skip()
            }
        }
        reader.endObject()
        if (reader.peek() == JsonToken.EndArray) {
            reader.endArray()
        }
        if (!hasv || !hasi || !haso) {
            throw IllegalArgumentException("Shape data was missing information.")
        }
        if (pointsArray.isEmpty()) {
            return ShapeData()
        }
        return ShapeData(
            c: closed,
            v: pointsArray,
            i: inTangents,
            o: outTangents
        )
    }
}
