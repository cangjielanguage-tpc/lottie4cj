/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

public class RoundedCornersParser {
    static func parse(reader: JsonReader): RoundedCorners {
        var name: String = ""
        var cornerRadius: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var hidden = false
        var ix: Int64 = -1
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "r" => cornerRadius.k = AnimatableValueParser.parseFloat(reader)
                case "hd" => hidden = reader.readValue<Bool>()
                case "ix" => ix = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        return RoundedCorners(nm: name, r: cornerRadius, hd: hidden, ix: ix)
    }
}
