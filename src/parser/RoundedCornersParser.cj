/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class RoundedCornersParser {

    private static let NAMES: Array<String> = [
        "nm", // 0
        "r",  // 1
        "hd"  // 2
    ]

    static func parse(reader: JsonObject): RoundedCorners {
        var name: String = ""
        var cornerRadius: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>() //用例1/2
        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { // "r"
            cornerRadius = AnimatableValueParser.parseFloat(reader[NAMES[1]])
        }
        if (reader.containsKey(NAMES[2])) { // "hd"
            hidden = reader[NAMES[2]].asBool().getValue()
        }

        let cm: RoundedCorners = RoundedCorners()
        cm.nm = name
        cm.r = cornerRadius
        cm.hd = hidden
        return cm
    }
}
