/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Utils structure for paring the animated json.
 */
package lottie.parser

class Utils {
    static func isAtLeastVersion(major: Int32, minor: Int32, patch: Int32, minMajor: Int32, minMinor: Int32,
        minPatch: Int32): Bool {
        if (major < minMajor) {
            return false
        } else if (major > minMajor) {
            return true
        }

        if (minor < minMinor) {
            return false
        } else if (minor > minMinor) {
            return true
        }

        return patch >= minPatch
    }

    public static func parseSAK(reader: JsonReader): AK {
        var a: Int64 = 0
        var k: Int64 = 0
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" => a = reader.readValue<Int64>()
                case "k" => k = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        return AK(a: a, k: k)
    }
}

public func handleAIX(reader: JsonReader, keyframe: ArrayKeyframeFloat64): Unit {
    while (reader.peek() == EndObject) {
        match (reader.readName()) {
            case "a" => keyframe.a = reader.readValue<Int64>()
            case "ix" => keyframe.ix = reader.readValue<Int64>()
            case _ => reader.skip()
        }
    }
}
