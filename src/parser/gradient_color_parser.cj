/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GradientColorParser structure.
 */
package lottie4cj.parser

public class GradientColorParser <: ValueParser<Array<Float64>> {
    private var colorPoints: Int64 = 0

    /**
     * Create a GradientColorParser instance based on the parameter.
     *
     * @param colorPoints - Type of Int64, the value of colorPoints.
     */
    public init(colorPoints: Int64) {
        this.colorPoints = colorPoints
    }

    /**
     * Animate the specified data in the json data, parsed into the corresponding array.
     *
     * @param reader - Type of JsonValue. Animate the specified data in the json data.
     * @return Type of Array<Float64>. An array of instances of the specified data that encapsulates the animation.
     */
    public func parse(reader: JsonValue): Array<Float64> {
        let ja: JsonArray = reader.asArray()
        let len: Int64 = ja.size()
        let array: Array<Float64> = Array<Float64>(len, item: 0.0)
        for (i in 0..len) {
            let num: Float64 = ja[i].asFloat().getValue()
            array[i] = num
        }
        return array
    }
}
