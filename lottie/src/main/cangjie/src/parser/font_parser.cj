/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class FontParser {
    static func parse(reader: JsonReader): Font {
        var family: String = ""
        var name: String = ""
        var style: String = ""
        var ascent: Float64 = 0.0

        var fOrigin: String = ""
        var origin: Int64 = -1
        var fPath: String = ""
        var fClass: String = ""
        var fWeight: String = ""

        reader.startObject()
        while (reader.peek() != JsonToken.EndObject) {
            let key = reader.readName()
            match (key) {
                case "fFamily" => family = reader.readValue<String>()
                case "fName" => name = reader.readValue<String>()
                case "fStyle" => style = reader.readValue<String>()
                case "ascent" => ascent = reader.readValue<Float64>()
                case "fOrigin" => fOrigin = reader.readValue<String>()
                case "origin" => origin = reader.readValue<Int64>()
                case "fPath" => fPath = reader.readValue<String>()
                case "fClass" => fClass = reader.readValue<String>()
                case "fWeight" => fWeight = reader.readValue<String>()
                case _ => reader.skip()
            }
        }
        reader.endObject()

        return Font(family, name, style, ascent, fOrigin, origin, fPath, fClass, fWeight)
    }
}
