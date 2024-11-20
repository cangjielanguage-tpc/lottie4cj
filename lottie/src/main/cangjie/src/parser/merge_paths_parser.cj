/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class MergePathsParser {
    static func parse(reader: JsonReader): MergePaths {
        var name: String = ""
        var mode: Int64 = 0
        var hidden: Bool = false
        while (reader.peek() != JsonToken.EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "mm" => mode = reader.readValue<Int64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case _ => reader.skip()
            }
        }
        return MergePaths(nm: name, mm: mode, hd: hidden)
    }
}
