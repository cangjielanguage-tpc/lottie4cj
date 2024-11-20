/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

import encoding.json.JsonArray
import encoding.json.JsonNull

class JsonUtils {

    /**
     * [r,g,b]
     */
    static func jsonToColor(reader: JsonReader): Array<Float64> {
        reader.startArray()
        let r = reader.readValue<Float64>()
        let g = reader.readValue<Float64>()
        let b = reader.readValue<Float64>()
        while (reader.peek() != EndArray) {
            reader.skip();
        }
        reader.endArray()
        return [r, g, b]
    }

    static func jsonToArrayFloat64(reader: JsonReader): Array<Float64> {
        var pointArray: ArrayList<Float64> = ArrayList<Float64>()
        reader.startArray()
        while (reader.peek() != EndArray) {
            pointArray.append(reader.readValue<Float64>())
        }
        reader.endArray()
        return pointArray.toArray()
    }

    static func jsonToPoints(reader: JsonReader): Array<PointF> {
        let points = ArrayList<PointF>()
        reader.startArray()
        while (reader.peek() == JsonToken.BeginArray) {
            reader.startArray()
            points.append(jsonToPoint(reader))
            reader.endArray()
        }
        reader.endArray()
        return points.toArray()
    }

    static func jsonToPoint(reader: JsonReader): PointF {
        if (reader.peek() == JsonToken.JsonNumber) {
            let _x = reader.readValue<Float64>()
            let _y = reader.readValue<Float64>()
            while (reader.peek() != EndArray) {
                reader.skip()
            }
            return PointF(x: _x, y: _y)
        } else if (reader.peek() == JsonToken.BeginArray) {
            return jsonArrayToPoint(reader)
        } else if (reader.peek() == JsonToken.BeginObject) {
            return jsonObjectToPoint(reader)
        } else {
            throw IllegalArgumentException("JsonValue is not a array or object type.")
        }
    }

    private static func jsonArrayToPoint(reader: JsonReader): PointF {
        let x: Float64
        let y: Float64
        reader.startArray()
        x = reader.readValue<Float64>()
        y = reader.readValue<Float64>()
        while (reader.peek() != JsonToken.EndArray) {
            reader.skip()
        }
        reader.endArray()
        return PointF(x: x, y: y)
    }

    private static func jsonObjectToPoint(reader: JsonReader): PointF {
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "x" => x = valueFromObject(reader)
                case "y" => y = valueFromObject(reader)
                case _ => reader.skip()
            }
        }
        reader.endObject()
        return PointF(x: x, y: y)
    }

    static func valueFromObject(reader: JsonReader): Float64 {
        let token: JsonToken = reader.peek().getOrThrow()
        match (token) {
            case JsonToken.JsonNumber => return reader.readValue<Float64>()
            case JsonToken.BeginArray =>
                reader.startArray()
                let val = reader.readValue<Float64>()
                while (reader.peek() != EndArray) {
                    reader.skip()
                }
                reader.endArray()
                return val
            case _ => throw IllegalArgumentException("Unknown value for token of type ${token.hashCode()}")
        }
    }
}
