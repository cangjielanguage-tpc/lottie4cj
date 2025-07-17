/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class ShapeGroupParser {
    static func parse(reader: JsonReader): ShapeGroup {
        var name: String = ""
        var hidden: Bool = false
        let items = ArrayList<ContentModel>()
        var cix: Int64 = 0
        var np: Int64 = 0
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "hd" => hidden = reader.readValue<Bool>()
                case "it" =>
                    reader.startArray()
                    while (reader.peek() != JsonToken.EndArray) {
                        items.add(ContentModelParser.parse(reader))
                    }
                    reader.endArray()
                case "cix" => cix = reader.readValue<Int64>()
                case "np" => np = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        return ShapeGroup(nm: name, it: items, hd: hidden, cix: cix, np: np)
    }
}
