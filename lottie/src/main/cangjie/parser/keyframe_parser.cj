/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class KeyframeParser {
    static func parse<T>(reader: JsonReader, valueParser: ValueParser<T>, animated: Bool): Keyframe<T> where T <: ToString {
        if (animated) {
            return parseKeyframe<T>(reader, valueParser)
        } else {
            return parseStaticValue<T>(reader, valueParser)
        }
    }

    static func parseKeyframe<T>(reader: JsonReader, valueParser: ValueParser<T>): Keyframe<T> where T <: ToString {
        var cp1: PointF = PointF()
        var cp2: PointF = PointF()

        var startFrame: Float64 = 0.0
        var startValue: Option<T> = Option<T>.None
        var endValue: Option<T> = Option<T>.None

        var hold: Int64 = 0
        var holdns: Array<String> = Array<String>()

        var pathCp1: Array<Float64> = Array<Float64>()
        var pathCp2: Array<Float64> = Array<Float64>()

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "t" => startFrame = reader.readValue<Float64>()
                case "s" => startValue = valueParser.parse(reader)
                case "e" => endValue = valueParser.parse(reader)
                case "o" => cp1 = JsonUtils.jsonToPoint(reader)
                case "i" => cp2 = JsonUtils.jsonToPoint(reader)
                case "h" => hold = reader.readValue<Int64>()
                case "to" => pathCp1 = JsonUtils.jsonToArrayFloat64(reader)
                case "ti" => pathCp2 = JsonUtils.jsonToArrayFloat64(reader)
                case "n" => if (reader.peek() == JsonToken.JsonString) {
                    holdns = [reader.readValue<String>()]
                } else if (reader.peek() == JsonToken.BeginArray) {
                    holdns = reader.readValue<Array<String>>()
                } else {
                    reader.skip()
                }
                case _ => reader.skip()
            }
        }
        reader.endObject()

        Keyframe<T>(
            t: startFrame,
            s: startValue,
            e: endValue,
            o: cp1,
            i: cp2,
            h: hold,
            to: pathCp1,
            n: holdns,
            ti: pathCp2
        )
    }

    private static func parseMultiDimensionalKeyframe<T>(reader: JsonReader, valueParser: ValueParser<T>): Keyframe<T> where T <: ToString {
        var cp1: PointF = PointF()
        var cp2: PointF = PointF()
        var xCp1: PointF = PointF()
        var xCp2: PointF = PointF()
        var yCp1: PointF = PointF()
        var yCp2: PointF = PointF()
        var startFrame = 0.0
        var startValue: Option<T> = Option<T>.None
        var endValue: Option<T> = Option<T>.None
        var hold: Int64 = 0
        var pathCp1: Array<Float64> = Array<Float64>()
        var pathCp2: Array<Float64> = Array<Float64>()

        var holdns: Array<String> = Array<String>()

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "t" => startFrame = reader.readValue<Float64>()
                case "s" => startValue = valueParser.parse(reader)
                case "e" => endValue = valueParser.parse(reader)
                case "o" => if (reader.peek() == JsonToken.BeginObject) {
                    reader.startObject()
                    var xCp1x = 0.0
                    var xCp1y = 0.0
                    var yCp1x = 0.0
                    var yCp1y = 0.0
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "x" => if (reader.peek() == JsonToken.JsonNumber) {
                                xCp1x = reader.readValue<Float64>()
                                yCp1x = xCp1x
                            } else {
                                reader.startArray()
                                xCp1x = reader.readValue<Float64>()
                                if (reader.peek() == JsonToken.JsonNumber) {
                                    yCp1x = reader.readValue<Float64>()
                                } else {
                                    yCp1x = xCp1x
                                }
                                reader.endArray()
                            }
                            case "y" => if (reader.peek() == JsonToken.JsonNumber) {
                                xCp1y = reader.readValue<Float64>()
                                yCp1y = xCp1y
                            } else {
                                reader.startArray()
                                xCp1y = reader.readValue<Float64>()
                                if (reader.peek() == JsonToken.JsonNumber) {
                                    yCp1y = reader.readValue<Float64>()
                                } else {
                                    yCp1y = xCp1y
                                }
                                reader.endArray()
                            }
                            case _ => reader.skip()
                        }
                    }

                    reader.endObject()
                } else {
                    cp1 = JsonUtils.jsonToPoint(reader)
                }
                case "i" => if (reader.peek() == JsonToken.BeginObject) {
                    reader.startObject()
                    var xCp2x = 0.0
                    var xCp2y = 0.0
                    var yCp2x = 0.0
                    var yCp2y = 0.0
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "x" => if (reader.peek() == JsonToken.JsonNumber) {
                                xCp2x = reader.readValue<Float64>()
                                yCp2x = xCp2x
                            } else {
                                reader.startArray()
                                xCp2x = reader.readValue<Float64>()
                                if (reader.peek() == JsonToken.JsonNumber) {
                                    yCp2x = reader.readValue<Float64>()
                                } else {
                                    yCp2x = xCp2x
                                }
                                while (reader.peek() != EndArray) {
                                    reader.skip()
                                }
                                reader.endArray()
                            }
                            case "y" => if (reader.peek() == JsonToken.JsonNumber) {
                                xCp2y = reader.readValue<Float64>()
                                yCp2y = xCp2y
                            } else {
                                reader.startArray()
                                xCp2y = reader.readValue<Float64>()
                                if (reader.peek() == JsonToken.JsonNumber) {
                                    yCp2y = reader.readValue<Float64>()
                                } else {
                                    yCp2y = xCp2y
                                }
                                while (reader.peek() != EndArray) {
                                    reader.skip()
                                }
                                reader.endArray()
                            }
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                } else {
                    cp2 = JsonUtils.jsonToPoint(reader)
                }
                case "h" => hold = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()

        let keyframe: Keyframe<T> = Keyframe<T>(
            t: startFrame,
            s: startValue,
            e: endValue,
            o: cp1,
            i: cp2,
            h: hold,
            to: pathCp1,
            n: holdns,
            ti: pathCp2
        )
        return keyframe
    }

    private static func parseStaticValue<T>(reader: JsonReader, valueParser: ValueParser<T>): Keyframe<T> where T <: ToString {
        let value: T = valueParser.parse(reader)
        return Keyframe<T>(k: value)
    }
}
