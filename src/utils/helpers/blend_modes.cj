/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BlendModes.
 */
package lottie4cj.utils.helpers

public class BlendModes {

    static let blendModeEnums: Array<String> = [
        "source-over",     // 0
        "multiply",        // 1
        "screen",          // 2
        "overlay",         // 3
        "darken",          // 4
        "lighten",         // 5
        "color-dodge",     // 6
        "color-burn",      // 7
        "hard-light",      // 8
        "soft-light",      // 9
        "difference",     // 10
        "exclusion",      // 11
        "hue",            // 12
        "saturation",     // 13
        "color",          // 14
        "luminosity"      // 15
    ]

    /**
     * Get blend mode.
     *
     * @param mode - Type of Int64.
     * @return Type of String.
     */
    public static func getBlendMode(mode: Int64): String {
        if (mode < 0 || mode > 15) {
            return ""
        }
        return blendModeEnums[mode]
    }
}

