/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.parser

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
        var shapes: Array<ContentModel> = Array<ContentModel>()

        if (let Some(v) <- reader.get(NAMES[0])) {
            character = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) {
            size = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) {
            width = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[3])) {
            style = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[4])) {
            fontFamily = v.asString().getValue()
        }

        if (let Some(v) <- reader.get(NAMES[5])) {
            let jo: JsonObject = v.asObject()
            if (let Some(val) <- jo.get(DATA_NAMES)) {
                let ja: JsonArray = val.asArray()
                let len: Int64 = ja.size()
                let EMPTY_CM: ContentModel = ContentModel()
                shapes = Array<ContentModel>(len, item: EMPTY_CM)
                for (i in 0..len) {
                    let jsonObject: JsonObject = ja[i].asObject()
                    shapes[i] = ContentModelParser.parse(jsonObject)
                }
            }
        }

        let data: CharsData = CharsData(shapes: shapes)
        return FontCharacter(data, character, size, width, style, fontFamily)
    }
}
