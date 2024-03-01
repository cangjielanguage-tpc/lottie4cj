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

        if (let Some(v) <- reader.get(NAMES[0])) { // "nm"
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "mm"
            mode = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) {  //"hd"
            hidden = v.asBool().getValue()
        }

        let cm: MergePaths = MergePaths(nm: name, mm: mode, hd: hidden)
        return cm
    }
}
