/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

class ShapeTrimPathParser {

    private static let NAMES: Array<String> = [
        "s",    // 0
        "e",    // 1
        "o",    // 2
        "nm",   // 3
        "m",    // 4
        "hd"    // 5
    ]

    static func parse(reader: JsonObject, composition: AnimationData): ShapeTrimPath {
        var name: String = ""
        var types: Int64 = 0

        var start: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>() 
        var end: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()   
        var offset: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) {  //"s"
            start = AnimatableValueParser.parseFloat(reader, composition, false)
        }
        if (reader.containsKey(NAMES[1])) {  //"e"
            end = AnimatableValueParser.parseFloat(reader, composition, false)
        }
        if (reader.containsKey(NAMES[2])) {  //"o"
            offset = AnimatableValueParser.parseFloat(reader, composition, false)
        }
        if (reader.containsKey(NAMES[3])) {  //"nm"
            name = reader[NAMES[3]].asString().getValue()
        }
        if (reader.containsKey(NAMES[4])) {  //"m"
            types = reader[NAMES[3]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[5])) {  //"hd"
            hidden = reader[NAMES[5]].asBool().getValue()
        }

        let cm: ShapeTrimPath = ShapeTrimPath()
        cm.s = start
        cm.e = end
        cm.o = offset
        cm.nm = name
        cm.m = types
        cm.hd = hidden
        return cm
    }
}
