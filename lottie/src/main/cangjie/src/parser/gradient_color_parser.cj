/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a GradientColorParser structure.
 */
package lottie.parser

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
    public func parse(reader: JsonReader): Array<Float64> {
        return reader.readValue<Array<Float64>>()
    }
}
