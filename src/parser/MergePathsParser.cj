/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

/* {"ty":"mm","mm":1,"nm":"Merge Paths 1","mn":"ADBE Vector Filter - Merge","hd":false} */
class MergePathsParser {

    private static let NAMES: Array<String> = [
        "nm",  // 0
        "mm",  // 1
        "hd"   // 2
    ]

    static func parse(reader: JsonObject): MergePaths {
        var name: String = ""
        var mode: Int64 = 0
        var hidden: Bool = false

        if (reader.containsKey(NAMES[0])) { // "nm"
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { // "mm"
            mode = reader[NAMES[1]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[2])) {  //"hd"
            hidden = reader[NAMES[2]].asBool().getValue()
        }

        let cm: MergePaths = MergePaths()
        cm.nm = name
        cm.mm = mode
        cm.hd = hidden
        return cm
    }
}
