/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ShapeGroupParser {

    private static let NAMES: Array<String> = [
        "nm",
        "hd",
        "it"
    ]

    static func parse(reader: JsonObject): ShapeGroup {
        var name: String = ""
        var hidden: Bool = false
        var items: ArrayList<ContentModel> = ArrayList<ContentModel>()

        if (reader.containsKey(NAMES[0])) {
            name = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) {
            hidden = reader[NAMES[1]].asBool().getValue()
        }
        if (reader.containsKey(NAMES[2])) {
            let ja: JsonArray = reader[NAMES[2]].asArray()
            for (i in 0..ja.size()) {
                let jo: JsonObject = ja[i].asObject()
                let newItem: ContentModel = ContentModelParser.parse(jo)
                if (newItem.types != -1) {
                    items.append(newItem)
                }
            }
        }

        return ShapeGroup(name, items, hidden)
    }
}
