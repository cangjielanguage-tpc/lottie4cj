/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class PathKeyframeParser {

    static func parse(reader: JsonValue, composition: AnimationData): Keyframe<PointF> {
        let jk: JsonKind = reader.kind()
        var animated: Bool = false
        if (equalsJsonKind(jk, JsonKind.JsObject)) {
            animated = true
        }

        //Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        let scale: Float64 = SCALE_FEFAULT
        let keyframe: Keyframe<PointF> = KeyframeParser.parse(reader, composition, scale, PathParser.INSTANCE, animated, false)

        return keyframe
    }
}
