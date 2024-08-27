/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Utils structure for paring the animated json.
 */
package lottie4cj.parser

class Utils {

    static func isAtLeastVersion(major: Int32, minor: Int32, patch: Int32, minMajor: Int32,
                                        minMinor: Int32, minPatch: Int32): Bool {
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

    public static let NAMES_A_AK: Array<String> = [
        "a",  //0
        "k"   //1
    ]
    
    public static func parseSAK(jo: JsonObject): AK {
        var a: Int64 = 0
        var k: Int64 = 0
        if (let Some(v) <- jo.get(NAMES_A_AK[0])) { //"a"
            a = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES_A_AK[1])) { //"k"
            k = v.asInt().getValue()
        }
        return AK(a: a, k: k)
    }
}
