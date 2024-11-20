/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class ShapeTrimPathParser {
    static let _defaultFloat64: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()

    static func parse(reader: JsonReader): ShapeTrimPath {
        var name: String = ""
        var types: Int64 = 0
        var start: ArrayKeyframeFloat64 = _defaultFloat64
        var end: ArrayKeyframeFloat64 = _defaultFloat64
        var offset: ArrayKeyframeFloat64 = _defaultFloat64
        var hidden = false
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "s" => start.k = AnimatableValueParser.parseFloat(reader)
                case "e" => end.k = AnimatableValueParser.parseFloat(reader)
                case "o" => offset.k = AnimatableValueParser.parseFloat(reader)
                case "nm" => name = reader.readValue<String>()
                case "m" => types = reader.readValue<Int64>()
                case "hd" => hidden = reader.readValue<Bool>()
                case _ => reader.skip()
            }
        }

        return ShapeTrimPath(
            s: start,
            e: end,
            o: offset,
            nm: name,
            m: types,
            hd: hidden
        )
    }
}
