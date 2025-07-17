/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class DropShadowEffectParser {
    func parse(reader: JsonReader): Array<Effect> {
        var ef = ArrayList<Effect>()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "ef" =>
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        ef.add(maybeParseInnerEffect(reader))
                    }
                    reader.endArray()
                case _ => reader.skip()
            }
        }
        return ef.toArray()
    }

    private func maybeParseInnerEffect(reader: JsonReader): Effect {
        var currentEffectName: String = ""
        var isCorrectType: Int64 = 0
        var v: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        var isNull: Bool = true

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => currentEffectName = reader.readValue<String>()
                case "v" => match (currentEffectName) {
                    case "Shadow Color" =>
                        v = AnimatableValueParser.parseColor(reader)
                        isNull = false
                    case "Opacity" | "Direction" =>
                        v = AnimatableValueParser.parseArrayFloat(reader)
                        isNull = false
                    case "Distance" | "Softness" =>
                        v = AnimatableValueParser.parseArrayFloat(reader)
                        isNull = false
                    case _ => reader.skip()
                }
                case "ty" => isCorrectType = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }

        reader.endObject()

        return Effect(
            ty: isCorrectType,
            nm: currentEffectName,
            v: ContentModelPK(k: v),
            isNull: isNull
        )
    }
}
