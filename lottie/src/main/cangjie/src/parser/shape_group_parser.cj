/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class ShapeGroupParser {

    private static let NAMES: Array<String> = [
        "nm",
        "hd",
        "it",
        "cix",
        "np"
    ]

    static func parse(reader: JsonObject): ShapeGroup {
        var name: String = ""
        var hidden: Bool = false
        var items: Array<ContentModel> = Array<ContentModel>()
        var cix: Int64 = 0

        if (let Some(v) <- reader.get(NAMES[0])) {
            name = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) {
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) {
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            let EMPTY_CM: ContentModel = ContentModel()
            items = Array<ContentModel>(len, item: EMPTY_CM)
            for (i in 0..len) {
                let jo: JsonObject = ja[i].asObject()
                let newItem: ContentModel = ContentModelParser.parse(jo)
                if (newItem.types != -1) {
                    items[i] = newItem
                }
            }
        }

        if (let Some(v) <- reader.get(NAMES[3])) { //"cix"
            cix = v.asInt().getValue()
        }
        var np: Int64 = 0
        if (let Some(v) <- reader.get(NAMES[4])) { //"np"
            np = v.asInt().getValue()
        }
        return ShapeGroup(nm: name, it: items, hd: hidden, cix: cix, np: np)
    }
}
