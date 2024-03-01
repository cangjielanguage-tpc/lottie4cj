/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class FontCharacterParser {
    
    //"chars"
    private static let NAMES: Array<String> = [
        "ch",       // 0
        "size",     // 1
        "w",        // 2
        "style",    // 3
        "fFamily",  // 4
        "data"      // 5
    ]
    private static let DATA_NAMES: String = "shapes"

    static func parse(reader: JsonObject): FontCharacter {
        var character: String = ""
        var size: Float64 = 0.0
        var width: Float64 = 0.0
        var style: String = ""
        var fontFamily: String = ""
        var shapes: ArrayList<ContentModel> = ArrayList<ContentModel>()

        if (reader.containsKey(NAMES[0])) {
            character = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) {
            size = reader[NAMES[1]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[2])) {
            width = reader[NAMES[2]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[3])) {
            style = reader[NAMES[3]].asString().getValue()
        }
        if (reader.containsKey(NAMES[4])) {
            fontFamily = reader[NAMES[4]].asString().getValue()
        }

        if (reader.containsKey(NAMES[5])) {
            let jo: JsonObject = reader[NAMES[5]].asObject()
            if (jo.size() > 0 && jo.containsKey(DATA_NAMES)) {
                let ja: JsonArray = jo[DATA_NAMES].asArray()
                for (i in 0..ja.size()) {
                    let jsonObject: JsonObject = ja[i].asObject()
                    shapes.append(ContentModelParser.parse(jsonObject))
                }
            }
        }

        let data: CharsData = CharsData(shapes)
        return FontCharacter(data, character, size, width, style, fontFamily)
    }
}
