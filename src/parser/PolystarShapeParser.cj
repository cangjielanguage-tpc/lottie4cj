/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class PolystarShapeParser {

    private static let NAMES: Array<String> = [
        "nm",   // 0
        "sy",   // 1
        "pt",   // 2
        "p",    // 3
        "r",    // 4
        "or",   // 5
        "os",   // 6
        "ir",   // 7
        "is",   // 8
        "hd",   // 9
        "d"     // 10
    ]

    static func parse(reader: JsonObject): PolystarShape {
        var name: String = ""
        var types: Int64 = 0
        var position: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue()

        var points: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  
        var rotation: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  
        var outerRadius: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  
        var outerRoundedness: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  
        var innerRadius: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  
        var innerRoundedness: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()  

        var hidden: Bool = false
        var reversed: Int64 = 0

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { // "sy"
            types = reader[NAMES[1]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[2])) { // "pt"
            points = AnimatableValueParser.parseFloat(reader[NAMES[2]])
        }
        if (reader.containsKey(NAMES[3])) { // "p"
            position = AnimatablePathValueParser.parseSplitPath(reader[NAMES[3]])
        }
        if (reader.containsKey(NAMES[4])) { // "r"
            rotation = AnimatableValueParser.parseFloat(reader[NAMES[4]])
        }
        if (reader.containsKey(NAMES[5])) { // "or"
            outerRadius = AnimatableValueParser.parseFloat(reader[NAMES[5]])
        }
        if (reader.containsKey(NAMES[6])) { // "os"
            outerRoundedness = AnimatableValueParser.parseFloat(reader[NAMES[6]])
        }
        if (reader.containsKey(NAMES[7])) { // "ir"
            innerRadius = AnimatableValueParser.parseFloat(reader[NAMES[7]])
        }
        if (reader.containsKey(NAMES[8])) { // "is"
            innerRoundedness = AnimatableValueParser.parseFloat(reader[NAMES[8]])
        }
        if (reader.containsKey(NAMES[9])) { // "hd"
            hidden = reader[NAMES[9]].asBool().getValue()
        }
        if (reader.containsKey(NAMES[10])) { // "d"
            reversed = reader[NAMES[10]].asInt().getValue()
        }

        let cm: PolystarShape = PolystarShape()
        cm.nm = name
        cm.nm = name
        cm.sy = types
        cm.pt = points
        cm.p = position
        cm.r = rotation
        cm.or = outerRadius
        cm.os = outerRoundedness
        cm.ir = innerRadius
        cm.is2 = innerRoundedness
        cm.hd = hidden
        cm.d = reversed
        return cm
    }
}
