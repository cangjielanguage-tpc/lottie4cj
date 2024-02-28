/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class CircleShapeParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "p",    // 1
        "s",    // 2
        "hd",   // 3
        "d"     // 4
    ]

    static func parse(reader: JsonObject, composition: AnimationData, d: Int64): CircleShape {
        var name: String = ""
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()
        var reversed: Int64 = 0
        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }

        if (reader.containsKey(NAMES[1])) {  //"p"
            position = AnimatablePathValueParser.parseSplitPath(reader[NAMES[1]], composition)
        }
        if (reader.containsKey(NAMES[2])) {  //"s"
            size = AnimatableValueParser.parsePoint(reader[NAMES[2]], composition)
        }
        if (reader.containsKey(NAMES[3])) {  //"hd"
            hidden = reader[NAMES[3]].asBool().getValue()
        }
        if (reader.containsKey(NAMES[4])) {  //"d"
            reversed = reader[NAMES[4]].asInt().getValue()
        }

        let cm: CircleShape = CircleShape()
        cm.nm = name
        cm.p = position
        cm.s = size
        cm.hd = hidden
        cm.d = reversed
        return cm
    }
}
