/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class RepeaterParser {
    static func parse(reader: JsonReader): Repeater {
        var name: String = ""
        var copies: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var offset: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        var transform: AnimatableTransform = AnimatableTransform()

        var hidden: Bool = false
        var ix: Int64 = -1
        var m: Int64 = -1
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => name = reader.readValue<String>()
                case "c" => copies.k = AnimatableValueParser.parseFloat(reader)
                case "o" => offset.k = AnimatableValueParser.parseFloat(reader)
                case "tr" => transform = AnimatableTransformParser.parse(reader, reader.readName())
                case "hd" => hidden = reader.readValue<Bool>()
                case "ix" => ix = reader.readValue<Int64>()
                case "m" => m = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        return Repeater(
            nm: name,
            c: copies,
            o: offset,
            tr: transform,
            hd: hidden,
            ix: ix,
            m: m
        )
    }

    private static func handleAIX(reader: JsonReader, keyframe: ArrayKeyframeFloat64): Unit {
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" => keyframe.a = reader.readValue<Int64>()
                case "ix" => keyframe.ix = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()
    }
}
