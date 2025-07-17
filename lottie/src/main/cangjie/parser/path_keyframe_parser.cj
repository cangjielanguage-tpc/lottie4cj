/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

class PathKeyframeParser {
    static func parse(reader: JsonReader): Keyframe<PointF> {
        let animated = reader.peek() == JsonToken.BeginObject
        return KeyframeParser.parse(reader, PathParser.INSTANCE, animated)
    }
}
