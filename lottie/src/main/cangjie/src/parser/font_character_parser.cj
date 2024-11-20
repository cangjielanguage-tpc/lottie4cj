/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class FontCharacterParser {
    private static let DATA_NAMES: String = "shapes"

    static func parse(reader: JsonReader): FontCharacter {
        var character: String = ""
        var size: Float64 = 0.0
        var width: Float64 = 0.0
        var style: String = ""
        var fontFamily: String = ""
        var shapes = ArrayList<ContentModel>()

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "ch" => character = reader.readValue<String>()
                case "size" => size = reader.readValue<Float64>()
                case "w" => width = reader.readValue<Float64>()
                case "style" => style = reader.readValue<String>()
                case "fFamily" => fontFamily = reader.readValue<String>()
                case "data" =>
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        if (reader.readName() == DATA_NAMES) {
                            reader.startArray()
                            while (reader.peek() != EndArray) {
                                shapes.append(ContentModelParser.parse(reader))
                            }
                            reader.endArray()
                        } else {
                            reader.skip()
                        }
                    }
                    reader.endObject()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        let data: CharsData = CharsData(shapes: shapes.toArray())
        return FontCharacter(data, character, size, width, style, fontFamily)
    }
}
