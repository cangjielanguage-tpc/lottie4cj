/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

public class ColorParser <: ValueParser<Array<Float64>> {

    /**
     * Get ColorParser instance.
     *
     * @return ColorParser instance.
     */
    public static let INSTANCE: ColorParser = ColorParser()

    private init() {}
    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonReader): Array<Float64> {
        let isArray = reader.peek() == JsonToken.BeginArray
        let res: Array<Float64> = Array<Float64>(4, repeat: 1.0)
        if (isArray) {
            reader.startArray()
        }
        res[0] = reader.readValue<Float64>()
        res[1] = reader.readValue<Float64>()
        res[2] = reader.readValue<Float64>()
        if (reader.peek() == JsonNumber) {
            res[3] = reader.readValue<Float64>()
        }
        if (isArray) {
            reader.endArray()
        }
        return res
    }
}
