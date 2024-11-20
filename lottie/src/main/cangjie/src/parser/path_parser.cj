/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.parser

public class PathParser <: ValueParser<PointF> {
    /**
     * Get PathParser instance.
     *
     * @return PathParser instance.
     */
    public static let INSTANCE = PathParser()

    private init() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of PointF. The parsing is encapsulated in this entity class.
     */
    public override func parse(reader: JsonReader): PointF {
        return JsonUtils.jsonToPoint(reader)
    }
}
