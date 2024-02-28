/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class GradientColorParser <: ValueParser<Array<Float64>> {
    private var colorPoints: Int64 = 0

    public init(colorPoints: Int64) {
        this.colorPoints = colorPoints
    }

    public func parse(reader: JsonValue, scale: Float64): Array<Float64> {
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
