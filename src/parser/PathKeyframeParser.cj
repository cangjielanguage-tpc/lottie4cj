/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class PathKeyframeParser {

    static func parse(reader: JsonValue): Keyframe<PointF> {
        let jk: JsonKind = reader.kind()
        var animated: Bool = false
        if (equalsJsonKind(jk, JsonKind.JsObject)) {
            animated = true
        }

        let keyframe: Keyframe<PointF> = KeyframeParser.parse(reader, PathParser.INSTANCE, animated)
        return keyframe
    }
}
