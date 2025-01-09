/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class KeyframesParser {
    static func parse<T>(reader: JsonReader, valueParser: ValueParser<T>): Array<Keyframe<T>> where T <: ToString {
        if (reader.peek() == JsonToken.JsonNull) {
            logger.log(LogLevel.INFO, "Lottie doesn't support expressions.")
            return Array<Keyframe<T>>()
        }
        let keyframes = ArrayList<Keyframe<T>>()

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "k" => if (reader.peek() == JsonToken.BeginArray) {
                    reader.startArray()
                    if (reader.peek() == JsonToken.JsonNumber) {
                        keyframes.append(KeyframeParser.parse(reader, valueParser, false))
                    } else if (reader.peek() == JsonToken.BeginObject) {
                        while (reader.peek() != JsonToken.EndArray) {
                            keyframes.append(KeyframeParser.parse(reader, valueParser, true))
                        }
                    }
                    reader.endArray()
                } else {
                    keyframes.append(KeyframeParser.parse(reader, valueParser, false))
                }
                case _ => reader.skip()
            }
        }
        reader.endObject()

        return keyframes.toArray()
    }
}
