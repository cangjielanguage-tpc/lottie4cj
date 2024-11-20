/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class BlurEffectParser {
    static func parse(reader: JsonReader): Array<Effect> {
        var ef = ArrayList<Effect>()
        while (reader.peek() != JsonToken.EndObject) {
            match (reader.readName()) {
                case "ef" =>
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        ef.append(maybeParseInnerEffect(reader))
                    }
                    reader.endArray()
                case _ => reader.skip()
            }
        }

        return ef.toArray()
    }

    private static func maybeParseInnerEffect(reader: JsonReader): Effect {
        var blurEffect: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var isCorrectType: Int64 = 0
        var isNull: Bool = true

        var nm: String = ""
        var mn: String = ""
        var ix: Int64 = 0
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "ty" => isCorrectType = reader.readValue<Int64>()
                case "v" => if (isCorrectType == 0) {
                    blurEffect = AnimatableValueParser.parseArrayFloat(reader)
                } else {
                    isNull = false
                    reader.skip()
                }
                case "nm" => nm = reader.readValue<String>()
                case "mn" => mn = reader.readValue<String>()
                case "ix" => ix = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()

        return Effect(ty: isCorrectType, nm: "", v: ContentModelPK(k: blurEffect.toArray()), mn: mn, ix: ix,
            isNull: isNull)
    }
}
