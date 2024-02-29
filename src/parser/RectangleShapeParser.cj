/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class RectangleShapeParser {

    private static let NAMES: Array<String> = [
        "nm",    // 0
        "p",     // 1
        "s",     // 2
        "r",     // 3
        "hd"     // 4
    ]

    static func parse(reader: JsonObject): RectangleShape {
        var name: String = ""

        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()
        var size: ArrayList<Keyframe<PointF>> = ArrayList<Keyframe<PointF>>()

        var roundedness: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }

        if (reader.containsKey(NAMES[1])) {  //"p"
            position = AnimatablePathValueParser.parseSplitPath(reader[NAMES[1]])
        }
        if (reader.containsKey(NAMES[2])) {  //"s"
            size = AnimatableValueParser.parsePoint(reader[NAMES[2]])
        }
        if (reader.containsKey(NAMES[3])) {  //"s"
            roundedness = AnimatableValueParser.parseFloat(reader[NAMES[3]])
        }

        if (reader.containsKey(NAMES[4])) {  //"hd"
            hidden = reader[NAMES[4]].asBool().getValue()
        }

        let cm: RectangleShape = RectangleShape()
        cm.nm = name
        cm.p = position
        cm.s = size
        cm.r = roundedness
        cm.hd = hidden
        return cm
    }
}
