/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj


class KeyframeParser {

    static let NAMES: Array<String> = [
        "t",  // 1
        "s",  // 2
        "e",  // 3
        "o",  // 4
        "i",  // 5
        "h",  // 6
        "to", // 7
        "ti"  // 8
    ]
    static let INTERPOLATOR_NAMES: Array<String> = [
        "x",  // 1
        "y"   // 2
    ]

    static func parse<T>(reader: JsonValue, composition: AnimationData, scale: Float64, valueParser: ValueParser<T>,
                            animated: Bool, multiDimensional: Bool): Keyframe<T> {

        if (animated) {
            return parseKeyframe<T>(composition, reader, scale, valueParser)
        } else {
            return parseStaticValue<T>(reader, scale, valueParser)
        }
    }

    private static func parseKeyframe<T>(composition: AnimationData, reader: JsonValue, scale: Float64, valueParser: ValueParser<T>): Keyframe<T> {

        var cp1: PointF = PointF()
        var cp2: PointF = PointF()

        var startFrame: Float64 = 0.0
        var startValue: Option<T> = Option<T>.None
        var endValue: Option<T> = Option<T>.None

        var hold: Int64 = 0

        // Only used by PathKeyframe
        var pathCp1: PointF = PointF()
        var pathCp2: PointF = PointF()


        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(NAMES[0])) { // t
            startFrame = jo[NAMES[0]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[1])) { // s
            startValue = valueParser.parse(reader, scale)
        }
        if (jo.containsKey(NAMES[2])) { // e
            endValue = valueParser.parse(reader, scale)
        }
        if (jo.containsKey(NAMES[3])) { // o
            cp1 = JsonUtils.jsonToPoint(reader, 1.0)
        }
        if (jo.containsKey(NAMES[4])) { // i
            cp2 = JsonUtils.jsonToPoint(reader, 1.0)
        }
        if (jo.containsKey(NAMES[5])) { // h
            hold = jo[NAMES[5]].asInt().getValue()
        }
        if (jo.containsKey(NAMES[6])) { // to
            pathCp1 = JsonUtils.jsonToPoint(reader, scale)
        }
        if (jo.containsKey(NAMES[7])) { // ti
            pathCp2 = JsonUtils.jsonToPoint(reader, scale)
        }

        let keyframe: Keyframe<T> = Keyframe<T>()
        keyframe.t = startFrame
        keyframe.s = startValue
        keyframe.e = endValue
        keyframe.o = cp1
        keyframe.i = cp2
        keyframe.h = hold
        keyframe.to = pathCp1
        keyframe.ti = pathCp2

        return keyframe
    }

    private static func parseStaticValue<T>(reader: JsonValue, scale: Float64, valueParser: ValueParser<T>): Keyframe<T> {
        let value: T = valueParser.parse(reader, scale)
        return Keyframe<T>(value)
    }

}
