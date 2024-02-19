/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj


class RepeaterParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "c",    // 1
        "o",    // 2
        "tr",   // 3
        "hd"    // 4
    ]

    static func parse(reader: JsonObject, composition: AnimationData): Repeater {
        var name: String = ""

        var copies: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var offset: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()
        var transform: AnimatableTransform = AnimatableTransform()

        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { // "c"
            copies = AnimatableValueParser.parseFloat(reader, composition, false)
        }
        if (reader.containsKey(NAMES[2])) { // "o"
            offset = AnimatableValueParser.parseFloat(reader, composition, false)
        }
        if (reader.containsKey(NAMES[3])) { // "tr"
            transform = AnimatableTransformParser.parse(reader, composition)
        }
        if (reader.containsKey(NAMES[4])) { //"hd"
            hidden = reader[NAMES[4]].asBool().getValue()
        }

        let cm: Repeater = Repeater()
        cm.nm = name
        cm.c = copies
        cm.o = offset
        cm.tr = transform
        cm.hd = hidden
        return cm
    }
}
