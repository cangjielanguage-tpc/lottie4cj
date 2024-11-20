/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

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
